//
//  FreeBoard.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct FreeBoardView: View {
    @StateObject var freeboardVM: FreeBoardViewModel = FreeBoardViewModel()

    var body: some View {
        ReusablePostsView(freeboardVM: freeboardVM)
            .frame(maxWidth: .infinity, alignment: .center)
            .overlay(alignment: .bottomTrailing){
                NavigationLink(destination: CreateNewPostView(){ post in
                    /// 사용자가 새롭게 작성한 게시물 insert
                    if let post = post {
                        freeboardVM.posts.insert(post, at: 0)
                        print("post insert Success")
                    }
                }) {
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
