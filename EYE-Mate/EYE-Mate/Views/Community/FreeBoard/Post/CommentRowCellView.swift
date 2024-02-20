//
//  CommentRowCellView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/13/24.
//

import SwiftUI

import Kingfisher

// MARK: Firebase 설계 후 다시 작성 (지금은 View 확인용 틀)
// MARK: 댓글 RowCell
struct CommentRowCellView: View {
    @Binding var comment: Comment
    
    @ObservedObject var commentVM: CommentViewModel
    
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
                if comment.userImageURL != nil {
                    KFImage(comment.userImageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 25))
                }
                
                // MARK: 댓글 작성자 이름
                Text("\(comment.userName)")
                    .padding(.leading, 5)
                    .font(.pretendardSemiBold_12)
                
                Spacer()
                
                // MARK: 댓글 좋아요 Btn
                HStack(spacing: 0) {
                    Button {
                        commentVM.likeComment(commentID: comment.id){ postID, commentIndex in
                            onUpdateComment(postID, commentIndex)
                        }
                    } label: {
                        Image(systemName: "heart")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.white)
                            .padding(5)
                    }
                    
                    Image(systemName: "poweron")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white)
                    
                    // MARK: 대댓글 기능 작성 필요
                    // MARK: 대댓글 작성 Btn
                    Button {
                        commentVM.startWritingReplyComment(commentID: comment.id) { commentID, commentIndex in
                            startWritingReplyComment(commentID, commentIndex)
                        }
                    } label: {
                        Image(systemName: "message")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.white)
                            .padding(5)
                    }
                    
                    Image(systemName: "poweron")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white)
                    
                    // TODO: 신고 기능 작성 필요
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
                                
                            } label: {
                                Label("신고", systemImage: "light.beacon.max.fill")
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .font(.system(size: 12))
                            .frame(height: 12)
                            .foregroundStyle(Color.white)
                            .padding(5)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 6).foregroundStyle(Color.customGreen).opacity(1))
            }
            
            Text("\(comment.comment)")
                .font(.pretendardRegular_12)
                .padding(.leading, 15)
                .padding(.top, 2)
            
            // MARK: 댓글 게시일, 좋아요 수
            HStack(alignment: .bottom){
                Text("\(comment.publishedDate.formatted(date: .numeric, time: .shortened))")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(.gray)
                    .padding(.leading, 15)
                    .padding(.top, 2)
                
                Image(systemName: comment.likedIDs.contains(commentVM.userUID) ? "heart.fill" : "heart")
                    .foregroundStyle(Color.customRed)
                    .padding(.trailing, -8)
                    .font(.system(size: 12))
                
                Text("\(comment.likedIDs.count)")
                    .font(.pretendardRegular_12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}
