//
//  AsyncImageView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI

struct AsyncImageView: View {
    var url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .modifier(MapImgModifier())
            case .failure(_):
                Color.customGreen
                    .modifier(MapImgModifier())
            case .empty:
                Color.black
                    .modifier(MapImgModifier())
            @unknown default:
                Color.white
                    .modifier(MapImgModifier())
            }
        }
    }
}
