//
//  PostContent.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/1/24.
//

import SwiftUI

import Kingfisher
import FirebaseFirestore
import FirebaseStorage

struct PostContent: View {
    @ObservedObject var postVM: PostViewModel
    
    var onEditPost: (String, String, String, [URL]?, [String]?) -> ()
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    
    @State var isShowEditPostView: Bool = false
    
    @AppStorage("user_UID") private var userUID: String = ""
    
    var body: some View {
        VStack {
            UserPostInfoView()
                .padding(.leading)
            
            VStack(alignment: .leading) {
                ContentView()
                
                PostInteractionView()
                    .padding(.top, 10)
            }
            .hAlign(.leading)
            .padding(.horizontal)
        }
        .frame(alignment: .top)
        .onAppear {
            postVM.addDocListener { updatedPost in
                if let post = updatedPost {
                    onUpdate(post)
                } else {
                    onDelete()
                }
            }
        }
        .onDisappear {
            postVM.removeDocListener()
        }
        .fullScreenCover(isPresented: $isShowEditPostView) {
            CreateNewPostView (isEditingPost: true, editingPost: postVM.post) { postID, postTitle, postContent, postImageURLs, imageReferenceIDs in
                self.postVM.post.postTitle = postTitle
                self.postVM.post.postContent = postContent
                self.postVM.post.postImageURLs = postImageURLs
                self.postVM.post.imageReferenceIDs = imageReferenceIDs
                
                onEditPost(postID, postTitle, postContent, postImageURLs, imageReferenceIDs)
            } onPost: { _ in}
        }
    }
    
    @ViewBuilder
    func UserPostInfoView() -> some View {
        // MARK: profileImage, userName, date 추후에 Firebase 연동
        HStack(spacing: 0) {
            // 사용자 프로필 이미지
            // KFImage
            KFImage(URL(string: postVM.post.userImageURL))
                .resizable()
                .frame(width: 35, height: 35)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
            // 사용자 닉네임, 게시 날짜
            HStack(alignment: .bottom){
                Text("\(postVM.post.userName)")
                    .font(.pretendardSemiBold_18)
                    .padding(.horizontal, 5)
                
                Text("\(postVM.post.publishedDate.formatted(date: .numeric, time: .shortened))")
                    .font(.pretendardRegular_12)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // 스크랩 버튼
            Button {
                postVM.postScrap()
            } label: {
                Image(systemName: postVM.post.scrapIDs.contains(userUID) ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 21))
                    .foregroundStyle(Color.customGreen)
                    .frame(width: 30, height: 35)
            }

            // Menu (신고 또는 삭제 -> 추후에 공유 등 추가 가능)
            Menu {
                // 본인의 게시물인 경우에 삭제 Btn, 아닌 경우 신고 Btn
                if userUID == postVM.post.userUID {
                    // 게시물 수정
                    Button(action:  {
                        isShowEditPostView = true
                    }) {
                        Label("수정", systemImage: "square.and.pencil.circle")
                    }
                    // 게시물 삭제
                    Button(role: .destructive ,action: postVM.deletePost) {
                        Label("삭제", systemImage: "trash")
                    }
                } else {
                    Button(role: .destructive) {
                        
                    } label: {
                        Label("신고", systemImage: "light.beacon.max.fill")
                            .tint(.red)
                            .foregroundStyle(.red)
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(.system(size: 21))
                    .foregroundColor(.customGreen)
                    .frame(width: 35, height: 35)
            }
        }
    }
    
    @ViewBuilder
    func ContentView() -> some View {
        // 게시물 제목
        Text("\(postVM.post.postTitle)")
            .font(.pretendardSemiBold_18)
            .padding(.top, 2)
        
        // 게시물 내용
        Text("\(postVM.post.postContent)")
            .font(.pretendardRegular_14)
            .padding(.top, 2)
            .padding(.vertical, 4)
        
        // 게시물 이미지
        if let imageURLs = postVM.post.postImageURLs {
            ImageCardView(imageURLs: imageURLs, postVM: postVM)
        }
    }
    
    @ViewBuilder
    func PostInteractionView() -> some View {
        // 좋아요, 댓글
        HStack {
            // 좋아요 버튼
            Button(action: postVM.likePost){
                Image(systemName: postVM.post.likedIDs.contains(userUID) ? "heart.fill" : "heart")
                    .foregroundStyle(Color.customRed)
                    .padding(.trailing, -8)
                    .font(.system(size: 15))
            }
            
            // 좋아요 수
            Text("\(postVM.post.likedIDs.count)")
                .font(.pretendardRegular_12)
            
            // 댓글 이미지
            Image(systemName: "message")
                .foregroundStyle(Color.customGreen)
                .padding(.trailing, -6)
                .font(.system(size: 15))
            
            // 댓글 수
            Text("\(postVM.post.comments.count + postVM.post.comments.reduce(0){$0 + $1.replyComments.count})")
                .font(.pretendardRegular_12)
        }
    }
}
