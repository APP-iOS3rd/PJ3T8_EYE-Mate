//
//  AsyncImageView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI
import Kingfisher

struct AsyncImageView: View {
    var url: URL?
    
    var body: some View {
        if let url = url {
            KFImage(url)
                .placeholder { //플레이스 홀더 설정
                    ProgressView()
                        .modifier(MapImgModifier())
                }.retry(maxCount: 3, interval: .seconds(5)) //재시도
                .onSuccess {r in //성공
                    print("succes: \(r)")
                }
                .onFailure { e in //실패
                    print("failure: \(e)")
                }
                .resizable()
                .scaledToFill()
                .modifier(MapImgModifier())
        }
        
        else {
            Color.white // Indicates an error.
                .modifier(MapImgModifier())
        }
    }
    
}
