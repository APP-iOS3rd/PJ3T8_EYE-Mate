//
//  ProfileImage.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI

struct ProfileImage: View {
    let imageState: ProfileViewModel.ImageState
    
    var body: some View {
        
        switch imageState {
        case .empty:
            Image("user")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
        case .loading:
            ProgressView()
        case let .success(image):
            image.resizable()
                .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
        }
    }
}
#Preview {
    ProfileImage(imageState: .empty)
}
