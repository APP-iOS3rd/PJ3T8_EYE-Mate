//
//  CommentView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/1/24.
//

import SwiftUI

import Kingfisher

struct CommentView: View {
    @ObservedObject var postVM: PostViewModel
    @StateObject var commentVM: CommentViewModel
    
    @Binding var showAlert: Bool
    
    // MARK: Local Data Update
    /// - 댓글  좋아요 업데이트
    var onUpdateComment: (String, Int, [String]) -> ()
    /// - 대댓글 좋아요 업데이트
    var onUpdateReplyComment: (String, Int, Int, [String]) -> ()
    /// - 대댓글 작성 Signal
    var startWritingReplyComment: (String, Int) -> ()
    /// - 댓글 삭제
    var deleteComment: (String, Int) -> ()
    /// - 대댓글 삭제
    var deleteReplyComment: (String, Int, Int) -> ()
    
    
    var body: some View {
        
        ForEach($commentVM.comments, id: \.self) { comment in
            VStack(spacing: 0) {
        
                // MARK: 댓글 Cell
                CommentRowCellView(comment: comment, commentVM: commentVM, showAlert: $showAlert) { postID, commentIndex in
                    /// 댓글 좋아요 업데이트
                    onUpdateComment(postID, commentIndex, commentVM.comments[commentIndex].likedIDs)
                } startWritingReplyComment: { commentID, commentIndex in
                    /// 대댓글 작성 Signal
                    startWritingReplyComment(commentID, commentIndex)
                } deleteComment: { postID, commentIndex in
                    /// 댓글 삭제
                    deleteComment(postID, commentIndex)
                }
                .padding(.horizontal,4)
                .background(Rectangle().foregroundStyle(Color.customGreen).opacity(postVM.replyWritingCommentID == comment.id ? 0.2 : 0))
                
                ForEach(comment.replyComments, id: \.self) { replyComment in
                    HStack {
                        Image(systemName: "arrow.turn.down.right")
                            .padding(.horizontal, 10)
                            .foregroundStyle(.gray)
                        
                        // MARK: 대댓글 Cell
                        ReplyCommentRowCellView(commentID: comment.id, replyComment: replyComment, commentVM: commentVM, showAlert: $showAlert) { postID, commentIndex, replyCommentIndex in
                            /// 대댓글 좋아요 업데이트
                            onUpdateReplyComment(postID, commentIndex, replyCommentIndex, commentVM.comments[commentIndex].replyComments[replyCommentIndex].likedIDs)
                        } deleteReplyComment: { postID, commentIndex, replyCommentIndex in
                            /// 대댓글  삭제
                            deleteReplyComment(postID, commentIndex, replyCommentIndex)
                        }
                    }
                    .padding(.vertical, 5)
                    .padding(.leading, 5)
                }
                
                HorizontalDivider(color: .btnGray, height: 1)
            }
        }
        .padding(.horizontal)
        .onChange(of: postVM.newComment) { newComment in
            /// - 새로운 댓글 작성시 Local Data Update
            if let newComment = newComment {
                commentVM.append(newComment: newComment)
                postVM.newComment = nil
            }
        }
        .onChange(of: postVM.newReplyComment) { newReplyComment in
            /// - 새로운 대댓글 작성시 Local Data Update
            if let newReplyComment = newReplyComment {
                guard let replyCommentIndex = postVM.replyWritingCommentIndex else { return }
                commentVM.append(at: replyCommentIndex, newReplyComment: newReplyComment)
                postVM.replyWritingCommentID = nil
                postVM.replyWritingCommentIndex = nil
                postVM.newReplyComment = nil
            }
        }
    }
}
