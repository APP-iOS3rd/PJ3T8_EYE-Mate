//
//  Profile.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("Login") var loggedIn: Bool = false
    @ObservedObject var profileViewModel: ProfileViewModel = ProfileViewModel.shared
    
    var body: some View {
        VStack{
            // TODO: 로그인 상태면 개인 프로필뷰
            if loggedIn {
                SettingView(profileViewModel: profileViewModel)
            } else {
                LoginView(isAlertView: .constant(false))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    ProfileView()
}
