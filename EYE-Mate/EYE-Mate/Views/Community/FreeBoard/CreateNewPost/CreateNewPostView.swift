//
//  CreateNewPostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/24/24.
//

import SwiftUI

struct CreateNewPostView: View {
    let isEditingPost: Bool
    let editingPost: Post?
    
    // Local Post Data Edit
    var onEditPost: (String, String, String, [URL]?, [String]?) -> ()
    // New Post Append at Local Data
    var onPost: (Post?)->()
    @StateObject private var createNewPostVM: CreateNewPostViewModel = CreateNewPostViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    init(isEditingPost: Bool, editingPost: Post? = nil, onEditPost: @escaping (String, String, String, [URL]?, [String]?) -> (), onPost: @escaping (Post?) -> Void) {
        self.isEditingPost = isEditingPost
        self.editingPost = editingPost
        self.onEditPost = onEditPost
        self.onPost = onPost
    }
    
    var body: some View {
        VStack {
            // 게시물 제목, 내용
            NewPostView(
                postTitle: $createNewPostVM.postTitle,
                postContent: $createNewPostVM.postContent,
                postImageDatasCount: $createNewPostVM.postImageDatas.count
            )
            
            // 이미지 Picker View
            ImagePickerView(
                createNewPostVM: createNewPostVM
            )
            
            // 작성 Button
            CustomButton(title: ( isEditingPost ? "수정완료" : "작성하기"), background: Color.customGreen, fontStyle: .pretendardBold_18, action: {
                closeKeyboard()
                
                if isEditingPost {
                    createNewPostVM.editPost { postID, postTitle, postContent, postImageURLs, imageReferenceIDs in
                        onEditPost(postID, postTitle, postContent, postImageURLs, imageReferenceIDs)
                        dismiss()
                    }
                } else {
                    createNewPostVM.createPost(){
                        onPost($0)
                        dismiss()
                    }
                }
            })
            .frame(maxHeight: 75)
            .disabled(!createNewPostVM.postButtonActive())
            .opacity(createNewPostVM.postButtonActive() ? 1 : 0.5)
        }
        .navigationTitle("글 쓰기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    closeKeyboard()
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
        })
        .overlay{
            LoadingView(show: $createNewPostVM.isLoading)
        }
        .onAppear {
            if isEditingPost, let post = editingPost {
                self.createNewPostVM.post = post
                self.createNewPostVM.postTitle = post.postTitle
                self.createNewPostVM.postContent = post.postContent
                
                if let imageURLs = post.postImageURLs {
                    self.createNewPostVM.loadImage(from: imageURLs)
                }
            }
        }
    }
}

//#Preview {
//    CreateNewPostView(onPost: {post in })
//}
