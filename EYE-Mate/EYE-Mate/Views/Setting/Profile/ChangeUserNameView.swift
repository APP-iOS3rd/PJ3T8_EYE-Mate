//
//  ChangeUserNameView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI

struct ChangeUserNameView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    // TODO: - profileVeiwModel에서 nickname 바인딩
    var nickname: String = ""
    @State var error: String = ""
    
    var body: some View {
        VStack {
            SettingNavigationTitle(title: "닉네임 변경")
            
            VStack(alignment: .leading) {
                Text("닉네임")
                
                ProfileNameTextField(nickname: nickname)

            }
            .padding(20)
            
            Text("\(error)")
                .font(.pretendardRegular_16)
                .foregroundStyle(Color.red)
            
            CustomBtn(title: "닉네임 설정", background: Color.customGreen, fontStyle: .pretendardRegular_20, action: {
                
                let result = profileViewModel.isValidName(nickname)
                
                if result != "true" {
                    error = result
                } else {
                    // TODO: - 다시 SettingView로 넘어오기
                    error = "success"
                }
            })
            .frame(height: 88)
            .padding(5)
        }
    }
}

#Preview {
    ChangeUserNameView()
        .environmentObject(ProfileViewModel())
}
