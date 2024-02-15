//
//  CommentView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/1/24.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    var comments: [Comment]
    
    var body: some View {
        ForEach(comments, id: \.self) { comment in
            CommentRowCellView(comment: comment)
            
            HorizontalDivider(color: .btnGray, height: 1)
        }
    }
}

// MARK: Firebase 설계 후 다시 작성 (지금은 View 확인용 틀)
// 각 댓글 RowCell
struct CommentRowCellView: View {
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                // MARK: 사용자 이미지 Firebase 연동후 수정
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
                
                Text("\(comment.userName)")
                    .padding(.leading, 5)
                    .font(.pretendardSemiBold_12)
                
                Spacer()
                
                // MARK: 대댓글 기능 작성 필요
                // 대댓글 버튼
                Button {
                } label: {
                    Image(systemName: "message")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.customGreen)
                }
                
                Image(systemName: "poweron")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.customGreen)
                    .padding(.horizontal, 2)
                
                // MARK: 좋아요 기능 작성 필요
                // 좋아요 버튼
                Button {
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.customGreen)
                }
                
                Image(systemName: "poweron")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.customGreen)
                    .padding(.horizontal, 2)
                
                // MARK: 신고 기능 작성 필요
                //
                Menu {
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("신고", systemImage: "light.beacon.max.fill")
                            .tint(.red)
                            .foregroundStyle(.red)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: 12))
                        .foregroundStyle(Color.customGreen)
                }
            }
            
            Text("\(comment.comment)")
                .font(.pretendardRegular_12)
                .padding(.leading, 15)
                .padding(.top, 2)
            
            HStack(alignment: .bottom){
                Text("\(comment.publishedDate.formatted(date: .numeric, time: .shortened))")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(.gray)
                    .padding(.leading, 15)
                    .padding(.top, 2)
                
                Image(systemName: "heart")
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

#Preview {
    CommentView(comments: FreeBoardViewModel().posts[0].comments)
}
