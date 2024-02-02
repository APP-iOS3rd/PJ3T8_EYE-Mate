//
//  Account.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var selected: PhotosPickerItem?
    @State var nickname: String = "어디로 가야 하오"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(spacing: 20) {
                    // TODO: back 버튼 추가
                    
                    PhotosPicker(selection: $profileViewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
                        CircularProfileImage(imageState: profileViewModel.imageState)
                    }
                    Text(nickname)
                        .font(.pretendardSemiBold_24)
                }
                .padding(.vertical, 50)
                
                SettingListView(profileViewModel: profileViewModel)
            }
        }
    }
}

#Preview {
    SettingView(profileViewModel: ProfileViewModel())
}
