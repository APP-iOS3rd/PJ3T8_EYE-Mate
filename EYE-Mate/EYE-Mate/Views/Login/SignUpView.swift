//
//  LoginView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/26.
//

import SwiftUI
import Combine
import FirebaseAuth


struct SignUpView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @Binding var signUpFlag: Bool
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 100)
            Text("EYE-Mate")
                .font(.pretendardBold_28)
                .foregroundStyle(Color.customGreen)
                .padding(.bottom, 40)
            
            VStack(spacing: 20) {
                Text("회원가입")
                    .font(.pretendardBold_20)
                    .foregroundStyle(Color.customGreen)
                PhoneNumberView(signUpFlag: $signUpFlag)
            }
        }
    }
    
}

#Preview {
    SignUpView(signUpFlag: .constant(false))
}



