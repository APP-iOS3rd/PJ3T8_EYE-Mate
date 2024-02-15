//
//  ImagePickerView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/1/24.
//

import SwiftUI
import PhotosUI

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

//#Preview {
//    ImagePickerView()
//}
