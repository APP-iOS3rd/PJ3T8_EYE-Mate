//
//  ProfileEditView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI


struct SignUpProfileView: View {
    @StateObject var profileViewModel = ProfileViewModel()
    @State var selected: PhotosPickerItem?
    @State var data: Data?
    @State var error: String = ""
    
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
            
            EditableProfileView(profileViewModel: profileViewModel)
                .padding(.bottom, 20)
            
            
            ProfileNameTextField()
                .padding(20)
            
            
            
            Text("\(error)")
                .font(.pretendardRegular_16)
                .foregroundStyle(Color.red)
            
            // 입력시작하면 그때부터 체크해서 빨간불
            CustomBtn(title: "시작하기", background: Color.customGreen, fontStyle: .pretendardRegular_20, action: {
                
                let result = profileViewModel.isValidName()
                
                if result != "success" {
                    error = result
                } else {
                    // HomeView로 profile 정보 가지고 넘어감
                    error = "success"
                    profileViewModel.uploadUserInfoToFirebase()
                }
            })
            .frame(height: 88)
            
            Spacer()
        }
        
    }
    
}

struct ProfileNameTextField: View {
    @AppStorage("user_name") private var userName: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("닉네임을 입력해주세요", text: $userName)
                .multilineTextAlignment(.center)
                .font(.pretendardRegular_18)
                .frame(height: 50)
                .background{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(radius: 4, x: 2, y: 2)
                        )
                }
            
            Text("\u{2022} 2~20자의 영문, 숫자, 한글, -, _ 만 사용 가능합니다")
                .monospacedDigit()
                .font(.pretendardRegular_16)
                .foregroundStyle(.gray)
                .padding(.leading, 5)
        }
    }
    
}
#Preview {
    SignUpProfileView()
}
