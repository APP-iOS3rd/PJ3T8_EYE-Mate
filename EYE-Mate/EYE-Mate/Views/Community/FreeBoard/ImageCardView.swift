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
                        .resizable()
                        .frame(maxWidth: 150, maxHeight: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 5)
                }
            }
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    ImageCardView(imageURLs: FreeBoardViewModel().posts[0].postImageURLs)
}
