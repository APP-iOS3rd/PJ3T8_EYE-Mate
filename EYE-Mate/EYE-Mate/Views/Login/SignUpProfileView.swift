//
//  ProfileEditView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI

struct SignUpProfileView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @AppStorage("oldUser_name") private var oldUserName: String = "EYE-Mate"
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @State var selectedItem: PhotosPickerItem? = nil
    @State var textName: String = ""
    @State var isButtonEnabled: Bool = false
    @FocusState private var keyFocused: Bool
    
    @ObservedObject var loginViewModel = LoginViewModel.shared
    
    var body: some View {
        VStack(spacing: 20) {
            CustomBackButton()
                .opacity(!keyFocused ? 1.0 : 0.0 )
            
            HStack {
                Text("EYE-Mate")
                    .foregroundColor(Color.customGreen)
                    .font(.pretendardSemiBold_24)
                +
                Text("에서 사용할\n프로필을 입력해주세요!")
                    .font(.pretendardRegular_24)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.bottom, 50)
            
            EditableProfileView(selectedItem: $selectedItem)
                .frame(width: 200, height: 200)
                .padding(.bottom, 20)
            
            // 닉네임 입력마다 실시간 유효성 확인
            ProfileNameTextField(textName: $textName, isButtonEnabled: $isButtonEnabled, keyFocused: $keyFocused)
                .padding(20)
            
            CustomButton(title: "시작하기", background: Color.customGreen, fontStyle: .pretendardRegular_20, action: {
                keyFocused = false
                self.userName = textName
                self.oldUserName = textName
                profileViewModel.imageSelection = selectedItem
                profileViewModel.uploadUserInfoToFirebase()
                if loginViewModel.showFullScreenCover {
                    loginViewModel.showFullScreenCover.toggle()
                } else {
                    router.navigateBack()
                }
            })
            .disabled(!isButtonEnabled)
            .disableWithOpacity(!isButtonEnabled)
            .frame(height: 88)
            
            Spacer()
        }
        .background(Color.white)
        .onTapGesture {
            keyFocused = false
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    SignUpProfileView()
}
