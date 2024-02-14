//
//  EditableProfileView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI


struct EditableProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var selectedItem: PhotosPickerItem?
    @State private var circleImage: Image = Image("user")
    
    var body: some View {
        
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                circleImage
                    .ProfileImageModifier()
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        let selectedImageData = data
                        let uiImage = UIImage(data: selectedImageData)
                        circleImage = Image(uiImage: uiImage!)
                    }
                }
            }
    }
    
}

#Preview {
    EditableProfileView(profileViewModel: ProfileViewModel(), selectedItem: .constant(nil) )
}
