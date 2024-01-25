//
//  CreateNewPostView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/24/24.
//

import SwiftUI
import PhotosUI

struct CreateNewPostView: View {
    @State private var postTitle: String = ""
    @State private var postContent: String = ""
    @State private var postContentPlaceHolder: String = "내용을 입력하세요."
    @State private var postImageDatas: [ImageData] = []
    
    
    @Environment(\.dismiss) private var dismiss
    @State private var showImagePicker: Bool = false
    @State private var photoItem: [PhotosPickerItem] = []
    
    
    var body: some View {
        VStack {
            VStack {
                TextField("제목", text: $postTitle)
                    .font(.pretendardRegular_18)
                
                HorizontalDivider(color: Color.gray)
                
                ZStack {
                    if postContent.isEmpty {
                        TextEditor(text: $postContentPlaceHolder)
                            .font(.pretendardMedium_12)
                            .foregroundStyle(Color.black)
                            .disabled(true)
                    }
                    
                    TextEditor(text: $postContent)
                        .overlay(alignment: .bottom){
                            HStack{
                                Image(systemName: "photo")
                                    .foregroundStyle(.gray)
                                Text("\(postImageDatas.count) / 10")
                                    .font(.pretendardMedium_12)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("\(postContent.count) / 1000")
                                    .font(.pretendardMedium_12)
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .font(.pretendardRegular_14)
                        .opacity(postContent.isEmpty ? 0.8 : 1)
                        .onChange(of: postContent) { oldValue, newValue in
                            // 글자 수 제한
                            if newValue.count > 1000 {
                                postContent = oldValue
                            }
                        }
                }
            }
            .padding(.horizontal, 30)
            
            ScrollView(.horizontal) {
                HStack {
                    Button {
                        showImagePicker.toggle()
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
                    
                    ForEach(postImageDatas.indices, id: \.self) { index in
                        if !postImageDatas.isEmpty, let image = UIImage(data: postImageDatas[index].data) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 75, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(alignment: .topTrailing){
                                    Button {
                                        withAnimation(.linear(duration: 0.25)){
                                            if let indexToRemove = postImageDatas.firstIndex(where: { $0.id == postImageDatas[index].id }){
                                                postImageDatas.remove(at: indexToRemove)
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .tint(Color.black)
                                    }
                                }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, -15)
            .scrollIndicators(.never)
            
            CustomBtn(title: "작성하기", background: Color.customGreen, fontStyle: .pretendardBold_18, action: {})
                .frame(maxHeight: 75)
                .disabled(postTitle.isEmpty || postContent.isEmpty)
                .opacity((postTitle.isEmpty || postContent.isEmpty) ? 0.5 : 1)

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
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem, maxSelectionCount: 10)
        .onChange(of: photoItem) { oldValue, newValue in
            if !photoItem.isEmpty {
                Task {
                    var imageDatas: [ImageData] = []
                    for item in photoItem {
                        if postImageDatas.count == 10 { return } // 사진 수 제한
                        if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData), let test = image.jpegData(compressionQuality: 0.9) {
                            imageDatas.append(ImageData(data: test))
                        }
                    }
                    
                    await MainActor.run {
                        postImageDatas.append(contentsOf: imageDatas)
                    }
                    photoItem = []
                }
            }
        }
    }
}

struct ImageData: Identifiable, Equatable {
    let id = UUID()
    let data: Data
}

#Preview {
    CreateNewPostView()
}
