//
//  CreateNewPostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/24/24.
//

import SwiftUI

struct CreateNewPostView: View {
    var onPost: (Post?)->()
    @StateObject private var createNewPostVM: CreateNewPostViewModel = CreateNewPostViewModel()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            NewPostView(
                postTitle: $createNewPostVM.postTitle,
                postContent: $createNewPostVM.postContent,
                postImageDatasCount: $createNewPostVM.postImageDatas.count
            )
            
            ImagePickerView(
                createNewPostVM: createNewPostVM
            )
            
            CustomBtn(title: "작성하기", background: Color.customGreen, fontStyle: .pretendardBold_18, action: {
                closeKeyboard()
                createNewPostVM.createPost(){
                    onPost($0)
                }
                dismiss()
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
    }
}

#Preview {
    CreateNewPostView(onPost: {post in })
}
