//
//  ReplyCommentRowCellView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/13/24.
//

import SwiftUI

import Kingfisher
import FirebaseFirestore

// MARK: 대댓글 RowCell
struct ReplyCommentRowCellView: View {
    var commentID: String?
    @Binding var replyComment: ReplyComment
    
    @ObservedObject var commentVM: CommentViewModel
    
    @Binding var showAlert: Bool
    
    @Binding var presentSheet: Bool
    @Binding var declarationText: String
    
    @AppStorage("Login") var loggedIn: Bool = false
    
    // MARK: Local Data Update
    /// - 대댓글 좋아요 업데이트
    var onUpdateReplyComment: (String, Int, Int) -> ()
    /// - 대댓글 삭제
    var deleteReplyComment: (String, Int, Int) -> ()
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                
                // MARK: 대댓글 작성자 프로필 이미지
                KFImage(URL(string: replyComment.userImageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
                
                // MARK: 대댓글 작성자 이름
                Text("\(replyComment.userName)")
                    .padding(.leading, 5)
                    .font(.pretendardSemiBold_12)
                
                Spacer()
                
                HStack(spacing: 0) {
                    // MARK: 신고 기능 작성 필요
                    // MARK: 대댓글 신고, 삭제 Menu
                    Menu {
                        if replyComment.userUID == commentVM.userUID {
                            /// 대댓글 삭제
                            Button(role: .destructive) {
                                if loggedIn {
                                    commentVM.deleteReplyComment(commentID: commentID, replyCommentID: replyComment.id) { postID, commentIndex, replyCommentIndex in
                                        deleteReplyComment(postID, commentIndex, replyCommentIndex)
                                    }
                                } else {
                                    showAlert = true
                                }
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        } else {
                            Button(role: .destructive) {
                                if loggedIn {
                                    presentSheet = true
                                    declarationText = "\ncommentDocumentID: \(String(describing: commentID))\nreplyCommentUserUID: \(replyComment.userUID)\nreplyCommentText: \(replyComment.comment)\n"
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
            
            // MARK: 대댓글 내용
            Text("\(replyComment.comment)")
                .font(.pretendardRegular_12)
                .padding(.leading, 15)
                .padding(.top, 2)
            
            // MARK: 대댓글 게시일, 좋아요 수
            HStack(alignment: .bottom){
                // MARK: 댓글 게시일
                Text("\(replyComment.publishedDate.getRelativeOrAbsoluteTime())")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(.gray)
                    .padding(.leading, 15)
                    .padding(.top, 2)
                
                Text("∙")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(Color(hex: "#898A8D"))
                
                // MARK: 좋아요 수
                Image(systemName: replyComment.likedIDs.contains(commentVM.userUID) ? "heart.fill" : "heart")
                    .foregroundStyle(replyComment.likedIDs.contains(commentVM.userUID) ? Color.customRed : Color(hex: "#929292"))
                    .padding(.trailing, -8)
                    .font(.system(size: 12))
                
                Text("\(replyComment.likedIDs.count)")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(Color(hex: "#898A8D"))

                // MARK: 좋아요 Button
                Button {
                    if loggedIn {
                        commentVM.likeReplyComment(commentID: commentID, replyCommentID: replyComment.id) { postID, commentIndex, replyCommentIndex in
                            onUpdateReplyComment(postID, commentIndex, replyCommentIndex)
                        }
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text(replyComment.likedIDs.contains(commentVM.userUID) ? "좋아요 취소" : "좋아요")
                        .font(.pretendardRegular_12)
                        .foregroundStyle(Color(hex: "#898A8D"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
        .padding(.horizontal, 5)
        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.gray).opacity(0.2))
    }
}
