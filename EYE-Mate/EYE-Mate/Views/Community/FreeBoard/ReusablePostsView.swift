//
//  ReusablePostsView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//


//ReusablePostsView - Profile 내가 쓴 글, 댓글 단 글, 스크랩 부분에서 재활용!!


import SwiftUI

struct ReusablePostsView: View {
//    @Binding var posts: [String]
    var posts: [String] = ["안약 과다 사용","안약 과다 사용2","안약 과다 사용3","안약 과다 사용4","안약 과다 사용5"]
    var body: some View {
        ScrollView {
            LazyVStack {
                Posts()
            }
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
            Text(post)
        }
    }
}

#Preview {
    ReusablePostsView()
}
