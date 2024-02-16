//
//  ProfileEditView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI

struct SignUpProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @AppStorage("user_name") private var userName: String = ""
    @State var selectedItem: PhotosPickerItem? = nil
    @State var textName: String = ""
    @State var isButtonEnabled: Bool = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack {
                Text("EYE-Mate")
                    .foregroundColor(Color.customGreen)
                    .font(.pretendardSemiBold_24)
                +
                Text("에서 사용할\n프로필을 입력해주세요!")
                    .font(.pretendardRegular_24)
            }
            .layoutPriority(1)
            .padding(.bottom, 50)
            
            EditableProfileView(profileViewModel: profileViewModel, selectedItem: $selectedItem)
                .frame(width: 200, height: 200)
                .padding(.bottom, 20)
            
            // 닉네임 입력마다 실시간 유효성 확인
            ProfileNameTextField(textName: $textName, isButtonEnabled: $isButtonEnabled)
                .padding(20)
            
            CustomButton(title: "시작하기", background: Color.customGreen, fontStyle: .pretendardRegular_20, action: {
                self.userName = textName
                profileViewModel.imageSelection = selectedItem
                profileViewModel.uploadUserInfoToFirebase()
                presentationMode.wrappedValue.dismiss()
                
            })
            .disabled(!isButtonEnabled) // false 이면 disabled
            .disableWithOpacity(!isButtonEnabled)
            .frame(height: 88)
            
            Spacer()
        }
        
    }
    
}

#Preview {
    SignUpProfileView()
}
