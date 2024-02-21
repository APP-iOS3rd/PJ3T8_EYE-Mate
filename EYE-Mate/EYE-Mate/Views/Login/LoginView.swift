//
//  LoginView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/31.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @State var signUpFlag: Bool = false
    // Alert를 통해 들어왔는지 확인
    let isAlertView: Bool
    
    // TODO: - loggedin에 따라 프로필/로그인 뷰 나올지 구현
    var body: some View {
        ScrollView {
            if !isAlertView {
                CustomBackButton()
            } else {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        loginViewModel.showFullScreenCover.toggle()
                    }, label: {
                        Image("close")
                    })
                }
                .padding(.trailing)
            }
            if signUpFlag {
                SignUpView(signUpFlag: $signUpFlag)
            }
            else {
                SignInView(signUpFlag: $signUpFlag)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    LoginView(isAlertView: false)
}
