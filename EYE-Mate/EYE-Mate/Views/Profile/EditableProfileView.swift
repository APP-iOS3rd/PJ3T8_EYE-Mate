//
//  CircularProfileImage.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI


struct EditableProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    var body: some View {
        
        PhotosPicker(selection: $profileViewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
            CircularProfileImage(imageState: profileViewModel.imageState)
                
        }
        
    }
}



struct CircularProfileImage: View {
    let imageState: ProfileViewModel.ImageState
    
    var body: some View {
        ProfileImage(imageState: imageState)
            .frame(width: 200, height: 200)
    }
}
#Preview {
    CircularProfileImage(imageState: .empty(Image("test")))
}
