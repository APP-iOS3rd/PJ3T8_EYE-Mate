//
//  ExpandImageView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/21/24.
//

import SwiftUI

struct ExpandImageView: View {
    @ObservedObject var postVM: PostViewModel
    @GestureState var draggingOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.bg
                .opacity(postVM.bgOpacity)
                .ignoresSafeArea()
            
            TabView(selection: $postVM.selectedImageIndex){
                ForEach(postVM.selectedImages.indices, id: \.self) { index in
                    postVM.selectedImages[index]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(index)
                        .scaleEffect(postVM.selectedImageIndex == index ? (postVM.imageScale > 1 ? postVM.imageScale : 1) : 1)
                        .offset(y: postVM.imageViewerOffset.height)
                        // 확대 제스쳐 Zoom
                        .gesture(
                            MagnificationGesture().onChanged({ value in
                                postVM.imageScale = value
                            }).onEnded({ _ in
                                withAnimation(.spring) {
                                    postVM.imageScale = 1
                                }
                            })
                            // Double to Zoom
                                .simultaneously(with: TapGesture(count: 2).onEnded({
                                    withAnimation {
                                        postVM.imageScale = postVM.imageScale > 1 ? 1 : 4
                                    }
                                }))
                        )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .overlay(alignment: .topTrailing) {
                // Close Button
                Button {
                    withAnimation(.default) {
                        postVM.showImageViewer.toggle()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.white.opacity(0.35))
                        .clipShape(Circle())
                }
                .padding(10)
                .opacity(postVM.bgOpacity)
            }
        }
        .gesture(DragGesture().updating($draggingOffset, body: { value, outValue, _ in
            outValue = value.translation
            postVM.onChangeImageViewer(value: draggingOffset)
        }).onEnded(postVM.onEnd(value:)))
        .onChange(of: postVM.selectedImageIndex) { newValue in
            postVM.imageScale = 1
        }
    }
}

extension Color {
    static let bg = Color.black.opacity(0.95)
}
