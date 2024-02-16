//
//  ChangeUserNameView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI

struct ChangeUserNameView: View {
    @AppStorage("user_name") private var userName: String = ""
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    @State var textName: String = ""
    @State var isButtonEnabled: Bool = false
    
    
    var body: some View {
        VStack {
            SettingNavigationTitle(leftBtnAction: {
                presentationMode.wrappedValue.dismiss()
            }, title: "닉네임 변경")
            
            VStack(alignment: .leading) {
                Text("닉네임")
                // TODO: - profileVeiwModel에서 nickname 바인딩
                ProfileNameTextField(textName: $textName, isButtonEnabled: $isButtonEnabled)

            }
            .padding(20)
            
            CustomButton(title: "닉네임 설정", background: Color.customGreen, fontStyle: .pretendardRegular_20, action: {
                self.userName = textName
                profileViewModel.uploadUserInfoToFirebase()
                presentationMode.wrappedValue.dismiss()
            })
            .disabled(!isButtonEnabled) // false 이면 disabled
            .disableWithOpacity(!isButtonEnabled)
            .frame(height: 88)
            .padding(5)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

#Preview {
    ChangeUserNameView()
        .environmentObject(ProfileViewModel())
}
