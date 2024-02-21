//
//  ImageActionButtonView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import SwiftUI
import PhotosUI

struct ImageActionSheetView: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @State var isPresented: Bool = false
    @State var showPicker: Bool = false
    @State var selectedImage: PhotosPickerItem?
    let listWidthSize = UIScreen.main.bounds.width - 70
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                isPresented = true
            } label: {
                HStack {
                    Text("프로필 사진 변경")
                        .font(.pretendardRegular_18)
                        .padding(.leading, 20)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .padding(.trailing, 20)
                        .foregroundStyle(Color.gray)
                }
                
            }
            .confirmationDialog(
                "프로필 사진 선택",
                isPresented: $isPresented,
                actions: {
                    Button("앨범에서 사진 선택") {
                        showPicker = true
                    }
                    Button("기본 이미지로 변경") {
                        //
                        profileViewModel.profileImage = Image("user")
                        profileViewModel.updateImageToStorage(image: UIImage(named: "user")!)
                    }
                }
            )
            .photosPicker(isPresented: $showPicker, selection: $profileViewModel.imageSelection)
            .frame(width: listWidthSize, height: 50)
            
            SettingListDivider()
            
        }
    }
}

#Preview {
    ImageActionSheetView()
}
