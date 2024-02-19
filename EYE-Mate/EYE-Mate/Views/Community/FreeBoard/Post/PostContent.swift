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
    
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    
//    @State private var docListener: ListenerRegistration?
    
    @AppStorage("user_UID") private var userUID: String = ""
    
    var body: some View {
        VStack {
            UserPostInfoView()
            
            VStack(alignment: .leading) {
                ContentView()
                
                PostInteractionView()
                    .padding(.top, 10)
            }
            .hAlign(.leading)
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
    }
    
    @ViewBuilder
    func UserPostInfoView() -> some View {
        // MARK: profileImage, userName, date 추후에 Firebase 연동
        HStack(spacing: 0) {
            // 사용자 프로필 이미지
            if postVM.post.userImageURL != nil {
                KFImage(postVM.post.userImageURL)
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
            }
            .padding(.trailing, 5)
            // Menu (신고 또는 삭제 -> 추후에 공유 등 추가 가능)
            Menu {
                // 본인의 게시물인 경우에 삭제 Btn, 아닌 경우 신고 Btn
                if userUID == postVM.post.userUID {
                    // 게시물 수정
                    Button(action:  {
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
                    .frame(height: 21)
                    .padding(.trailing, -10)
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
            ImageCardView(imageURLs: imageURLs)
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
