//
//  PostContent.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/1/24.
//

import SwiftUI
import Kingfisher

struct PostContent: View {
//    var postIndex: Int
    @State var post: Post
    
    var body: some View {
        VStack {
            // MARK: profileImage, userName, date 추후에 Firebase 연동
            HStack(spacing: 0) {
                // 사용자 프로필 이미지
                if post.userImageURL != nil {
                    KFImage(post.userImageURL)
                        .resizable()
                        .frame(width: 35, height: 35)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 35))
                }
                
                // 사용자 닉네임, 게시 날짜
                HStack(alignment: .bottom){
                    Text("\(post.userName)")
                        .font(.pretendardSemiBold_18)
                        .padding(.horizontal, 5)
                    
                    Text("\(post.publishedDate.formatted(date: .numeric, time: .shortened))")
                        .font(.pretendardRegular_12)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                // 스크랩 버튼
                Button {
                } label: {
                    Image(systemName: "bookmark")
                        .font(.system(size: 21))
                        .foregroundStyle(Color.customGreen)
                }
                
                // Menu (신고 -> 추후에 공유 등 추가 가능)
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
                        .font(.system(size: 21))
                        .foregroundColor(.customGreen)
                }
            }
            
            VStack(alignment: .leading) {
                // 게시물 제목
                Text("\(post.postTitle)")
                    .font(.pretendardSemiBold_18)
                    .padding(.top, 2)
                
                // 게시물 내용
                Text("\(post.postContent)")
                    .font(.pretendardRegular_14)
                    .padding(.top, 2)
                    .padding(.vertical, 4)
                
                // 게시물 이미지
                if !post.postImageURLs.isEmpty {
                    ImageCardView(imageURLs: post.postImageURLs)
                }
                
                // 좋아요, 댓글
                HStack {
                    // 좋아요 버튼
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                            .foregroundStyle(Color.customRed)
                            .padding(.trailing, -8)
                            .font(.system(size: 15))
                    }
                    
                    // 좋아요 수
                    Text("\(post.likedIDs.count)")
                        .font(.pretendardRegular_12)
                    
                    // 댓글 이미지
                    Image(systemName: "message")
                        .foregroundStyle(Color.customGreen)
                        .padding(.trailing, -6)
                        .font(.system(size: 15))
                    
                    // 댓글 수
                    Text("\(post.comments.count)")
                        .font(.pretendardRegular_12)
                }
                .padding(.top, 10)
            }
        }
        .frame(alignment: .top)
    }
}

#Preview {
    PostContent(post: FreeBoardViewModel().posts[0])
}
