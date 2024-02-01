//
//  CircularProfileImage.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI

struct CircularProfileImage: View {
    let imageState: ProfileViewModel.ImageState
    var body: some View {
        ProfileImage(imageState: imageState)
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .background(Color.white)
    }
}
#Preview {
    CircularProfileImage(imageState: .empty)
}
