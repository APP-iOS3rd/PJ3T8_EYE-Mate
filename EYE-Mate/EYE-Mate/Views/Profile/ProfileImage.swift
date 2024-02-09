//
//  ProfileImage.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import FirebaseStorage

struct ProfileImage: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    let imageState: ProfileViewModel.ImageState
    
    var body: some View {
        
        switch imageState {
        case let .empty(image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
        case .loading:
            ProgressView()
            
        case let .success(image):
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
        }
    }
    
}
#Preview {
    ProfileImage(imageState: .empty(Image("user")))
}
