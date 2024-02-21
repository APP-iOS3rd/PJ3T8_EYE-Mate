//
//  ImageCardView.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/1/24.
//

import SwiftUI

import Kingfisher

struct ImageCardView: View {
    var imageURLs: [URL]
    @ObservedObject var postVM: PostViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(imageURLs.indices, id: \.self) { index in
                    Button {
                        postVM.selectedImageIndex = index
                        withAnimation {
                            postVM.showImageViewer.toggle()
                        }
                    } label: {
                        KFImage(imageURLs[index])
                            .placeholder {
                                ProgressView()
                                    .modifier(MapImageModifier())
                            }
                            .retry(maxCount: 3, interval: .seconds(5))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.trailing, 5)
                }
            }
        }
        .scrollIndicators(.never)
    }
}
