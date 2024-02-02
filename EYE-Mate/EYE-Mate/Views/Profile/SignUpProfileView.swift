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
    @State var nickname: String = ""
    @State var data: Data?
    @State var error: String = ""
    // 테스트
    let namesToTest = ["myName123", "user-name", "한글이름", "longusername12345678901", "-invalid", "a", "한글테스트"]
    
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
            
            VStack(spacing: 0) {
                Text("2~20자의 영문, 숫자, 한글, -, _ 만 사용 가능합니다")
                    .monospacedDigit()
                    .font(.pretendardRegular_16)
                    .foregroundStyle(.gray)
                TextField("닉네임을 입력해주세요", text: $nickname)
                    .multilineTextAlignment(.center)
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
                    .padding()
            }
            
            Text("\(error)")
                .font(.pretendardRegular_16)
                .foregroundStyle(Color.red)
            
            // 입력시작하면 그때부터 체크해서 빨간불
            CustomBtn(title: "시작하기", background: Color.customGreen, fontStyle: .pretendardRegular_20, action: {
                
                let result = profileViewModel.isValidName(nickname)
                
                if result != "true" {
                    error = result
                } else {
                    // HomeView로 profile 정보 가지고 넘어감
                    error = "success"
                }
            })
            .frame(height: 88)
            
            Spacer()
            
        }
        
        
        
    }
    
}



#Preview {
    SignUpProfileView()
}
