//
//  FreeBoard.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct FreeBoardView: View {
    @State private var recentsPosts: [String] = ["안약 과다 사용", "안약 과다 사용2", "안약 과다 사용3", "안약 과다 사용4", "안약 과다 사용5", "안약 과다 사용6", "안약 과다 사용7"]
    var body: some View {
        ReusablePostsView(posts: $recentsPosts)
            .frame(maxWidth: .infinity, alignment: .center)
        
            .overlay(alignment: .bottomTrailing){
                NavigationLink(destination: CreateNewPostView()) {
                    Circle()
                        .foregroundStyle(Color.customGreen)
                        .frame(maxHeight: 60)
                        .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 0, x: 2, y: 2)
                        .overlay{
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(.white)
                        }
                }
                .padding()
            }
        
    }
}

#Preview {
    FreeBoardView()
}
