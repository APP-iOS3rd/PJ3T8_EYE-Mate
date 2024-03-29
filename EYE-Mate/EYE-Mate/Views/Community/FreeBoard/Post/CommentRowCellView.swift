//
//  CommentRowCellView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/13/24.
//

import SwiftUI

import Kingfisher
import FirebaseFirestore

// MARK: Firebase 설계 후 다시 작성 (지금은 View 확인용 틀)
// MARK: 댓글 RowCell
struct CommentRowCellView: View {
    @Binding var comment: Comment
    
    @ObservedObject var commentVM: CommentViewModel
    
    @Binding var showAlert: Bool
    
    @Binding var presentSheet: Bool
    @Binding var declarationText: String
    
    @AppStorage("Login") var loggedIn: Bool = false
    
    // MARK: Local Data Update
    /// - 댓글 좋아요 업데이트
    var onUpdateComment: (String, Int) -> ()
    /// - 대댓글 작성 Signal
    var startWritingReplyComment: (String, Int) -> ()
    /// - 댓글 삭제
    var deleteComment: (String, Int) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                
                // MARK: 댓글 작성자 이미지
                KFImage(URL(string: comment.userImageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                
                // MARK: 댓글 작성자 이름
                Text("\(comment.userName)")
//                Text("\(userName)")
                    .padding(.leading, 5)
                    .font(.pretendardSemiBold_12)
                
                Spacer()
              
                HStack(spacing: 0) {
                    // MARK: 신고 기능 작성 필요
                    // MARK: 댓글 신고, 삭제 메뉴
                    Menu {
                        if comment.userUID == commentVM.userUID {
                            /// 댓글 삭제 Action
                            Button(role: .destructive) {
                                withAnimation {
                                    commentVM.deleteComment(commentID: comment.id) { postID, commentIndex in
                                        deleteComment(postID, commentIndex)
                                    }
                                }
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        } else {
                            Button(role: .destructive) {
                                if loggedIn {
                                    presentSheet = true
                                    declarationText = "commentDocumentID: \(String(describing: comment.id))\ncommentUserUID: \(comment.userUID)\ncommentText: \(comment.comment)\n"
                                } else {
                                    showAlert = true
                                }
                            } label: {
                                Label("신고", systemImage: "light.beacon.max.fill")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.system(size: 12))
                            .frame(height: 12)
                            .foregroundStyle(Color(hex: "#5E6060"))
                            .padding(5)
                    }
                }
            }
            
            Text("\(comment.comment)")
                .font(.pretendardRegular_12)
                .padding(.leading, 15)
                .padding(.top, 2)
            
            // MARK: 댓글 게시일, 좋아요 수
            HStack(alignment: .bottom){
                // MARK: 댓글 게시일
                Text("\(comment.publishedDate.getRelativeOrAbsoluteTime())")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(.gray)
                    .padding(.leading, 15)
                    .padding(.top, 2)
                
                Text("∙")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(Color(hex: "#898A8D"))
                
                // MARK: 좋아요 수
                Image(systemName: comment.likedIDs.contains(commentVM.userUID) ? "heart.fill" : "heart")
                    .foregroundStyle(comment.likedIDs.contains(commentVM.userUID) ? Color.customRed : Color(hex: "#929292"))
                    .padding(.trailing, -8)
                    .font(.system(size: 12))
                
                Text("\(comment.likedIDs.count)")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(Color(hex: "#898A8D"))
                
                // MARK: 좋아요 Button
                Button {
                    if loggedIn {
                        commentVM.likeComment(commentID: comment.id){ postID, commentIndex in
                            onUpdateComment(postID, commentIndex)
                        }
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text(comment.likedIDs.contains(commentVM.userUID) ? "좋아요 취소" : "좋아요")
                        .font(.pretendardRegular_12)
                        .foregroundStyle(Color(hex: "#898A8D"))
                }
                
                Text("∙")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(Color(hex: "#898A8D"))

                // MARK: 답글달기 Button
                Button {
                    if loggedIn {
                        commentVM.startWritingReplyComment(commentID: comment.id) { commentID, commentIndex in
                            startWritingReplyComment(commentID, commentIndex)
                        }
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text("답글달기")
                        .font(.pretendardRegular_12)
                        .foregroundStyle(Color(hex: "#898A8D"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}
