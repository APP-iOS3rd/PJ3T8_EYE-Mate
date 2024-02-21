//
//  PostCardView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//

import SwiftUI

import Kingfisher

struct PostCardView: View {
    var post: Post
    
    @AppStorage("user_UID") var userUID: String = ""
    
//    var post: String
    var body: some View {
        HStack {
            VStack {
                // postTitle, Date
                HStack(spacing: 8) {
                    Text("\(post.postTitle)")
                        .font(.pretendardSemiBold_14)
                        .lineLimit(1)
                    
                    Text("\(post.publishedDate.formatted(date: .numeric, time: .shortened))")
                        .font(.pretendardRegular_10)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // postContent
                Text("\(post.postContent)")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.pretendardRegular_12)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
                    
                // liked, disliked, comment
                HStack {
                    Image(systemName: post.likedIDs.contains(userUID) ? "heart.fill" : "heart")
                        .foregroundStyle(Color.customRed)
                        .padding(.trailing, -8)
                        .font(.system(size: 15))
                    
                    Text("\(post.likedIDs.count)")
                        .font(.pretendardRegular_12)
                    
                    Image(systemName: "message")
                        .foregroundStyle(Color.customGreen)
                        .padding(.trailing, -6)
                        .font(.system(size: 15))
                    
                    Text("\(post.comments.count + post.comments.reduce(0){$0 + $1.replyComments.count})")
                        .font(.pretendardRegular_12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(.black)
            .padding(.vertical, 10)
            .padding(.leading, 10)
            
            // postImage
            if let imageURL = post.postImageURLs, !imageURL.isEmpty{
                KFImage(imageURL[0])
                    .placeholder { //플레이스 홀더 설정
                        ProgressView()
                            .modifier(MapImageModifier())
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 75, height: 75)
                    .background(.black)
                    .padding(.trailing)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)
                .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
        )
        .padding(.horizontal, 18)
        .padding(.vertical, 4)
    }
}
