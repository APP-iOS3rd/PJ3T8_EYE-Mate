//
//  ReusablePostsView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//


//ReusablePostsView - Profile 내가 쓴 글, 댓글 단 글, 스크랩 부분에서 재활용!!


import SwiftUI

struct ReusablePostsView: View {
    @ObservedObject var freeboardVM: FreeBoardViewModel

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
        ForEach(freeboardVM.posts.indices) { index in
            NavigationLink {
                PostView(postIndex: index, freeboardVM: freeboardVM)
            } label: {
                PostCardView(postIndex: index, freeboardVM: freeboardVM)
            }
        }
    }
}
//
//#Preview {
//    ReusablePostsView()
//}
