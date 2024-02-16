//
//  ReusablePostsView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/23/24.
//


// MARK: ReusablePostsView - Profile 내가 쓴 글, 댓글 단 글, 스크랩 부분에서 재활용!!
import SwiftUI

struct ReusablePostsView: View {
    @ObservedObject var freeboardVM: FreeBoardViewModel

    var body: some View {
        // 게시물 목록
        ScrollView {
            LazyVStack {
                if freeboardVM.isFetching {
                    ProgressView()
                } else {
                    if freeboardVM.posts.isEmpty {
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    } else {
                        // MARK: 게시물 리스트
                        PostList()
                    }
                }
            }
            .padding(.top, 10)
        }
        .scrollIndicators(.never)
        .refreshable {
            /// 위로 스크롤 당겨서 새로고침
            Task {
                await freeboardVM.refreshable()
            }
        }
        .task {
            // MARK: 처음에 한번 Firebase에서 posts 받아오기
            guard freeboardVM.posts.isEmpty else {return}
            await freeboardVM.fetchPosts()
        }
    }
    
    @ViewBuilder
    func PostList() -> some View {
        ForEach(freeboardVM.posts) { post in
            NavigationLink {
                /// 게시물로 Navigation
                PostView(postVM: PostViewModel(post: post)){ updatedPost in
                    /// 게시물 좋아요 Local Data 업데이트
                    if let index = freeboardVM.posts.firstIndex(where: { post in post.id == updatedPost.id }) {
                        freeboardVM.posts[index].likedIDs = updatedPost.likedIDs
                    }
                } onDelete: {
                    /// 게시물 삭제 Local Data 업데이트
                    withAnimation(.easeInOut(duration: 0.25)) {
                        freeboardVM.posts.removeAll { post.id == $0.id }
                    }
                } writeComment: { updatedPost in
                    /// 댓글 작성 Local Data 업데이트
                    if let index = freeboardVM.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                        freeboardVM.posts[index].comments = updatedPost.comments
                    }
                } writeReplyComment: { postID, commentIndex, replyComment in
                    /// 대댓글 작성 Local data 업데이트
                    if let index = freeboardVM.posts.firstIndex(where: { $0.id == postID }) {
                        freeboardVM.posts[index].comments[commentIndex].replyComments.append(replyComment)
                    }
                } onUpdateComment: { postID, commentIndex, likedIDs in
                    /// 댓글 좋아요 Local Data 업데이트
                    if let index = freeboardVM.posts.firstIndex(where: { $0.id == postID }) {
                        freeboardVM.posts[index].comments[commentIndex].likedIDs = likedIDs
                    }
                } onUpdateReplyComment: { postID, commentIndex, replyCommentIndex, likedIDs in
                    /// 대댓글 좋아요 Local Data 업데이트
                    if let index = freeboardVM.posts.firstIndex(where: { $0.id == postID}) {
                        freeboardVM.posts[index].comments[commentIndex].replyComments[replyCommentIndex].likedIDs = likedIDs
                    }
                } deleteComment: { postID, commentIndex in
                    /// 댓글 삭제
                    if let index = freeboardVM.posts.firstIndex(where: { $0.id == postID }){
                        freeboardVM.posts[index].comments.remove(at: commentIndex)
                    }
                } deleteReplyComment: { postID, commentIndex, replyCommentIndex in
                    /// 대댓글 삭제
                    if let index = freeboardVM.posts.firstIndex(where: { $0.id == postID }) {
                        freeboardVM.posts[index].comments[commentIndex].replyComments.remove(at: replyCommentIndex)
                    }
                }
            } label: {
                PostCardView(post: post)
            }
        }
    }
}
