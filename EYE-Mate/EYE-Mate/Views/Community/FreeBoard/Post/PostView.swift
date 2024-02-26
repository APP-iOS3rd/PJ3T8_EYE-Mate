//
//  PostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/26/24.
//

import SwiftUI

import Kingfisher
import SlackKit

struct PostView: View {
    @StateObject var postVM: PostViewModel
    
    // MARK: Local Data Update
    /// - 게시물 좋아요 업데이트
    var onUpdate: (Post) -> ()
    /// - 게시물 삭제
    var onDelete: () -> ()
    /// - 사용자가 댓글 작성시 업데이트
    var writeComment: (Post) -> ()
    /// - 대댓글 작성시 업데이트
    var writeReplyComment: (String, Int, ReplyComment) -> ()
    /// - 댓글 좋아요 업데이트
    var onUpdateComment: (String, Int, [String]) -> ()
    /// - 대댓글 좋아요 업데이트
    var onUpdateReplyComment: (String, Int, Int, [String]) -> ()
    /// - 댓글 삭제
    var deleteComment: (String, Int) -> ()
    /// - 대댓글 삭제
    var deleteReplyComment: (String, Int, Int) -> ()
    /// - 게시물 수정
    var onEditPost: (String, String, String, [URL]?, [String]?) -> ()
    
    private let declarationStrings: [String] = ["게시판 성격에 부적절함",
                                        "같은 내용 도배",
                                        "욕설/인신공격",
                                        "음란/선정성",
                                        "불법정보", "개인정보 노출", 
                                        "상업적 광고 및 판매", "정당/정치인 비하 및 선거운동"]
    
    @FocusState var commentTextFieldIsFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("Login") var loggedIn: Bool = false
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @State var showAlert: Bool = false

    @State var presentSheet: Bool = false
    @State var declarationIndex: Int = 0
    @State var showDeclarationAlert: Bool = false
    @ObservedObject var csViewModel: CustomerServiceViewModel = CustomerServiceViewModel()
    @State var declarationText = ""
    
    // MARK: - body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HorizontalDivider(color: .buttonGray, height: 2)
                
                ScrollView{
                    // MARK: 게시물 내용
                    PostContent(postVM: postVM, showAlert: $showAlert, presentSheet: $presentSheet, declarationText: $declarationText) { postID, postTitle, postContent, postImageURLs, imageReferenceIDs in
                        onEditPost(postID, postTitle, postContent, postImageURLs, imageReferenceIDs)
                    } onUpdate: { updatedPost in
                        /// 게시물 좋아요 업데이트
                        postVM.post.likedIDs = updatedPost.likedIDs
                        postVM.post.scrapIDs = updatedPost.scrapIDs
                        onUpdate(updatedPost)
                    } onDelete: {
                        /// 게시물 삭제
                        onDelete()
                        postVM.isLoading = false
                        dismiss()
                    }
                    .padding(.top)
                    
                    HorizontalDivider(color: .buttonGray, height: 2)
                    
                    // MARK: 댓글
                    if !postVM.post.comments.isEmpty {
                        CommentView(postVM: postVM, commentVM: CommentViewModel(comments: postVM.post.comments, selectedPostID: postVM.post.id, isLoading: $postVM.isLoading), showAlert: $showAlert, presentSheet: $presentSheet, declarationText: $declarationText)
                        { postID, commentIndex, likedIDs in
                            /// 댓글 좋아요 업데이트
                            postVM.post.comments[commentIndex].likedIDs = likedIDs
                            onUpdateComment(postID, commentIndex, likedIDs)
                            
                        } onUpdateReplyComment: { postID, commentIndex, replyCommentIndex, likedIDs in
                            /// 대댓글 좋아요 업데이트
                            postVM.post.comments[commentIndex].replyComments[replyCommentIndex].likedIDs = likedIDs
                            onUpdateReplyComment(postID, commentIndex, replyCommentIndex, likedIDs)
                        } startWritingReplyComment: { commentID, commentIndex in
                            /// 대댓글 작성 Signal
                            withAnimation {
                                postVM.startWritingReplyComment(commentID: commentID, commentIndex: commentIndex)
                                commentTextFieldIsFocused = true
                            }
                        } deleteComment: { postID, commentIndex in
                            /// 댓글 삭제
                            postVM.post.comments.remove(at: commentIndex)
                            deleteComment(postID, commentIndex)
                        } deleteReplyComment: { postID, commentIndex, replyCommentIndex in
                            /// 대댓글 삭제
                            postVM.post.comments[commentIndex].replyComments.remove(at: replyCommentIndex)
                            deleteReplyComment(postID, commentIndex, replyCommentIndex)
                        }
                    } else {
                        Spacer()
                    }
                }
                .scrollIndicators(.never)
                .onTapGesture {
                    /// 댓글 입력란 바깥 터치시 Keyboard Close
                    commentTextFieldIsFocused = false
                    postVM.resetCommentInputView()
                }
                
                // MARK: 댓글 입력
                CommentInputView()
                    .padding(postVM.commentViewPadding)
                
            } // VStack
            
            if showAlert {
                CustomAlertView(
                    title: "저희 아직 친구가 아니네요.",
                    message: "로그인이 필요해요!",
                    leftButtonTitle: "취소",
                    leftButtonAction: { showAlert = false },
                    rightButtonTitle: "로그인",
                    rightButtonAction: {
                        loginViewModel.showFullScreenCover.toggle()
                        showAlert = false
                    })
            }
            
            if showDeclarationAlert {
                CustomAlertView(
                    title: "\(declarationStrings[declarationIndex])",
                    message: "신고 사유에 해당하는지 검토 후 처리됩니다.",
                    leftButtonTitle: "취소",
                    leftButtonAction: { showDeclarationAlert = false },
                    rightButtonTitle: "신고",
                    rightButtonAction: {
                        showDeclarationAlert = false
                        // Slack 전송
                        csViewModel.sendMessage(menu: CustomerServiceMenu.Name.report, text: "postDocumentID: \(String(describing: postVM.post.id!))\n\(declarationText)\n신고 사유: \(declarationStrings[declarationIndex])\n")
                    })
            }
        } // ZStack
        .vAlign(.top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            // MARK: Back Button
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    /// 현재 화면 dismiss
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
            
            // MARK: Navigation Title
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "leaf")
                        .foregroundStyle(Color(hex: "#28CD41"))
                    Text("자유 게시판")
                        .font(.pretendardSemiBold_24)
                }
            }
        })
        .overlay {
            LoadingView(show: $postVM.isLoading)
        }
        .overlay {
            ZStack {
                if postVM.showImageViewer {
                    ExpandImageView(postVM: postVM)
                }
            }
        }
        .onChange(of: postVM.post.postImageURLs) { newValue in
            if let postImageURLs = newValue {
                postVM.selectedImages = []
                for url in postImageURLs {
                    postVM.selectedImages.append(KFImage(url))
                }
            }
        }
        .navigationBarHidden(postVM.showImageViewer)
        .fullScreenCover(isPresented: $loginViewModel.showFullScreenCover, content: {
            LoginView(isAlertView: true)
        })
        .animation(.easeInOut(duration: 0.2), value: showAlert)
        .onChange(of: loggedIn) { newValue in
            print("\(loggedIn)")
        }
        .sheet(isPresented: $presentSheet, content: {
            DeclarationView()
        })
    }
    
    // MARK: - 댓글 입력 View
    @ViewBuilder
    func CommentInputView() -> some View {
        HStack(alignment: .bottom) {
            TextField("", text: $postVM.commentText, prompt: Text(postVM.commentPlaceholder), axis: .vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.pretendardRegular_14)
                .focused($commentTextFieldIsFocused)
                .onChange(of: commentTextFieldIsFocused) { newValue in
                    withAnimation {
                        if newValue {
                            postVM.commentViewCornerRadius = 0
                            postVM.commentViewPadding = 0
                        } else {
                            postVM.commentViewCornerRadius = 10
                            postVM.commentViewPadding = 15
                        }
                    }
                }
                .frame(minHeight: 28)
            
            if !postVM.commentText.isEmpty {
                Button {
                    if loggedIn {
                        if postVM.replyWritingCommentID == nil {
                            /// 댓글 작성 Action
                            postVM.writeComment() {
                                commentTextFieldIsFocused = false
                                writeComment(postVM.post)
                            }
                        } else {
                            /// 대댓글 작성 Action
                            postVM.writeReplyComment() { postID, commentIndex, replyComment in
                                commentTextFieldIsFocused = false
                                writeReplyComment(postID, commentIndex, replyComment)
                            }
                        }
                    } else {
                        showAlert = true
                        commentTextFieldIsFocused = false
                        postVM.resetCommentInputView()
                    }
                } label: {
                    Text("등록")
                        .font(.pretendardSemiBold_14)
                        .foregroundStyle(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal,12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.customGreen)
                        )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: postVM.commentViewCornerRadius)
                .foregroundStyle(Color(hex: "#EEEEEE"))
        )
        .onTapGesture {
            commentTextFieldIsFocused = true
        }
    }
    
    // MARK: - 신고 Sheet
    @ViewBuilder
    func DeclarationView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "light.beacon.max.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 20))
                Text("신고")
                    .font(.pretendardBold_20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 15)
            
            ForEach(declarationStrings.indices, id: \.self) { index in
                Button {
                    declarationIndex = index
                    presentSheet = false
                    showDeclarationAlert = true
                } label: {
                    Text("\(declarationStrings[index])")
                        .font(.pretendardMedium_16)
                        .foregroundStyle(.black)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HorizontalDivider(color: Color(hex: "#D9D9D9"), height: 1)
            }
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large])
    }
}
