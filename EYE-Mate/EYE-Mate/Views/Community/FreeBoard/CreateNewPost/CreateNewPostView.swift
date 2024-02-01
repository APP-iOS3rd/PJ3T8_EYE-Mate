//
//  CreateNewPostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/24/24.
//

import SwiftUI
import PhotosUI

struct CreateNewPostView: View {
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
            
            CustomBtn(title: "작성하기", background: Color.customGreen, fontStyle: .pretendardBold_18, action: {})
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
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
            }
        })
        .overlay{
            if createNewPostVM.isLoading {
                ProgressView()
            }
        }
    }
}

struct NewPostView: View {
    @Binding var postTitle: String
    @Binding var postContent: String
    @State private var postContentPlaceHolder: String = "내용을 입력하세요."
    var postImageDatasCount: Int
    
    var body: some View {
        VStack {
            // 제목 입력
            TextField("제목", text: $postTitle)
                .font(.pretendardRegular_18)
            
            HorizontalDivider(color: Color.gray)
            
            // 내용 입력
            ZStack {
                // placeholder TextEditor
                if postContent.isEmpty {
                    TextEditor(text: $postContentPlaceHolder)
                        .font(.pretendardMedium_12)
                        .foregroundStyle(Color.black)
                        .disabled(true)
                }
                
                // 실제 입력될 TextEditor
                TextEditor(text: $postContent)
                    .overlay(alignment: .bottom){
                        HStack{
                            Image(systemName: "photo")
                                .foregroundStyle(.gray)
                            
                            // 첨부 사진 수
                            Text("\(postImageDatasCount) / 10")
                                .font(.pretendardMedium_12)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            // 내용 글자 수
                            Text("\(postContent.count) / 1000")
                                .font(.pretendardMedium_12)
                                .foregroundStyle(Color.gray)
                        }
                    }
                    .font(.pretendardRegular_14)
                    .opacity(postContent.isEmpty ? 0.8 : 1)
                    .onChange(of: postContent) { newValue in
                        if newValue.count > 1000 {
                            postContent.removeLast()
                        }
                    }
            }
        }
        .padding(.horizontal, 30)
    }
}

struct ImagePickerView: View {
    @ObservedObject var createNewPostVM: CreateNewPostViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Button {
                    createNewPostVM.showImagePicker.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, style: StrokeStyle(dash: [5]))
                        .frame(width: 75, height: 75)
                        .overlay{
                            Image(systemName: "plus")
                                .tint(.gray)
                                .font(.system(size: 25))
                        }
                }
                
                ForEach(createNewPostVM.postImageDatas.indices, id: \.self) { index in
                    if !createNewPostVM.postImageDatas.isEmpty, let image = UIImage(data: createNewPostVM.postImageDatas[index]) {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            Button {
                                withAnimation(.linear(duration: 0.25)){
                                    createNewPostVM.removeImage(at: index)
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .tint(Color.black)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                            .offset(x: 5, y: -5)
                        }
                        .frame(height: 85)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 85)
        .padding(.horizontal)
        .padding(.bottom, -15)
        .scrollIndicators(.never)
        .photosPicker(isPresented: $createNewPostVM.showImagePicker, selection: $createNewPostVM.photoItem, maxSelectionCount: 10)
        .onChange(of: createNewPostVM.photoItem) { _ in
            createNewPostVM.addSelectedImages()
        }
    }
}

#Preview {
    CreateNewPostView()
}
