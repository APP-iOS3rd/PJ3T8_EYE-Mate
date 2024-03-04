//
//  ProfileListView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/06.
//

import SwiftUI
import PhotosUI

struct ProfileListView: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @State var isPresented = false
    
    var body: some View {
        ImageActionSheetView()
        
        SettingCellView(title: "닉네임 변경", destination: ChangeUserNameView())
    }
}

#Preview {
    ProfileListView()
}
