//
//  ReusablePostsView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//


//ReusablePostsView - Profile 내가 쓴 글, 댓글 단 글, 스크랩 부분에서 재활용!!


import SwiftUI

struct ReusablePostsView: View {
    @Binding var posts: [String] // 게시물 목록 Data (추후에 Firebase에서 받아와야함)
    var body: some View {
        // 게시물 목록
        ScrollView {
            LazyVStack {
                Posts()
            }
            .padding(.top, 10)
        }
        .scrollIndicators(.never)
        .refreshable {
            // 위로 스크롤 당겨서 새로고침
        }
        .task {
            // MARK: 처음에 한번 Firebase에서 posts 받아오기
        }
    }
    
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts, id: \.self) { post in
            Button{
                
            }label: {
                PostCardView(post: post)
            }
        }
    }
}
//
//#Preview {
//    ReusablePostsView()
//}
