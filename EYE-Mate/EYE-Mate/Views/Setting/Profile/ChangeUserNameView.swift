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
    @State var error: String = ""
    
    var body: some View {
        VStack {
            SettingNavigationTitle(leftBtnAction: {
                presentationMode.wrappedValue.dismiss()
            }, title: "닉네임 변경")
            
            VStack(alignment: .leading) {
                Text("닉네임")
                // TODO: - profileVeiwModel에서 nickname 바인딩
                ProfileNameTextField()

            }
            .padding(20)
            
            Text("\(error)")
                .font(.pretendardRegular_16)
                .foregroundStyle(Color.red)
            
            CustomBtn(title: "닉네임 설정", background: Color.customGreen, fontStyle: .pretendardRegular_20, action: {
                
                Task {
                    let result = try await profileViewModel.isValidName()
                    
                    if result != "success" {
                        error = result
                    } else {
                        error = "success"
                        profileViewModel.updateNameToFirebase()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
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
