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
            ProfileImage(imageState: profileViewModel.imageState)
        }
        
    }
}

#Preview {
    EditableProfileView(profileViewModel: ProfileViewModel())
}
