//
//  LoginView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/31.
//

import SwiftUI

struct LoginView: View {
    @State var signUpFlag: Bool = false
    
    // TODO: - loggedin에 따라 프로필/로그인 뷰 나올지 구현
    var body: some View {
        NavigationStack {
            if signUpFlag {
                SignUpView(signUpFlag: $signUpFlag)
            }
            else {
                SignInView(signUpFlag: $signUpFlag)
            }
        }
    }
}

#Preview {
    LoginView()
}
