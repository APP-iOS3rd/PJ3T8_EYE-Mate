//
//  PostCardView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//

import SwiftUI

struct PostCardView: View {
    var post: String
    var body: some View {
        HStack {
            VStack {
                // postTitle, Date
                HStack(spacing: 8) {
                    Text("\(post)")
                        .font(.pretendardSemiBold_14)
                        .lineLimit(1)
                    
                    Text("10월 11일")
                        .font(.pretendardRegular_10)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // postContent
                Text("전문의의 정확한 검진 없이 안약을 과다 사용하면 오히려 눈 건강..")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.pretendardRegular_12)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
                    
                // liked, disliked
                HStack {
                    Image(systemName: "heart")
                        .foregroundStyle(Color.customRed)
                        .padding(.trailing, -8)
                        .font(.system(size: 15))
                    
                    Text("41")
                        .font(.pretendardRegular_12)
                    
                    Image(systemName: "message")
                        .foregroundStyle(Color.customGreen)
                        .padding(.trailing, -6)
                        .font(.system(size: 15))
                    
                    Text("43")
                        .font(.pretendardRegular_12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(.black)
            .padding(.vertical, 10)
            .padding(.leading, 10)
            
            // postImage
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: 75, maxHeight: 75)
                .foregroundStyle(.red)
                .padding(.trailing)
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

#Preview {
    PostCardView(post: "안약 과다 사용")
}
