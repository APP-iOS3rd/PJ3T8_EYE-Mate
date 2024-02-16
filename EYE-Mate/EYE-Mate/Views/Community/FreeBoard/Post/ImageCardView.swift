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
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                ForEach(imageURLs, id: \.self) {
                    KFImage($0)
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
                        .padding(.trailing, 5)
                }
            }
        }
        .scrollIndicators(.never)
    }
}

//#Preview {
//    ImageCardView(imageURLs: FreeBoardViewModel().posts[0].postImageURLs)
//}
