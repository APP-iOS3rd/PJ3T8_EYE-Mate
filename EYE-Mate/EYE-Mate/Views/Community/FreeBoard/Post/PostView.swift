//
//  PostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/26/24.
//

import SwiftUI

import Kingfisher

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

    
    @FocusState var commentTextFieldisFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HorizontalDivider(color: .btnGray, height: 2)
            
            ScrollView{
                // MARK: 게시물 내용
                PostContent(postVM: postVM) { postID, postTitle, postContent, postImageURLs, imageReferenceIDs in
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

                HorizontalDivider(color: .btnGray, height: 2)
                
                // MARK: 댓글
                if !postVM.post.comments.isEmpty {
                    CommentView(postVM: postVM, commentVM: CommentViewModel(comments: postVM.post.comments, selectedPostID: postVM.post.id, isLoading: $postVM.isLoading))
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
                            commentTextFieldisFocused = true
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
                withAnimation {
                    commentTextFieldisFocused = false
                    postVM.replyWritingCommentID = nil
                    postVM.replyWritingCommentIndex = nil
                    postVM.commentPlaceholder = "댓글을 입력해보세요..."
                    postVM.commentText = ""
                }
            }
            
            // MARK: 댓글 입력
            CommentInputView()
                .padding(postVM.commentViewPadding)
        }
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
    }
    
    // MARK: 댓글 입력 View
    @ViewBuilder
    func CommentInputView() -> some View {
        HStack(alignment: .bottom) {
            TextField("", text: $postVM.commentText, prompt: Text(postVM.commentPlaceholder), axis: .vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.pretendardRegular_14)
                .focused($commentTextFieldisFocused)
                .onChange(of: commentTextFieldisFocused) { newValue in
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
                    if postVM.replyWritingCommentID == nil {
                        /// 댓글 작성 Action
                        postVM.writeComment() {
                            commentTextFieldisFocused = false
                            writeComment(postVM.post)
                        }
                    } else {
                        /// 대댓글 작성 Action
                        postVM.writeReplyComment() { postID, commentIndex, replyComment in
                            commentTextFieldisFocused = false
                            writeReplyComment(postID, commentIndex, replyComment)
                        }
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
            commentTextFieldisFocused = true
        }
    }
}
