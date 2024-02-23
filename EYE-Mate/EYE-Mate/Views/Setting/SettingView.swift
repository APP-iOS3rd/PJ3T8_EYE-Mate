//
//  Account.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @Environment(\.presentationMode) var presentationMode

    @AppStorage("Login") private var login: Bool = false
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL

    @State var isLogoutAlert: Bool = false
    
    @State var isSignoutAlert: Bool = false

    var body: some View {
        ZStack {
            VStack {
                CustomBackButton()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        profileViewModel.profileImage
                            .ProfileImageModifier()
                            .frame(width: 200, height: 200)

                        Text(userName)
                            .font(.pretendardSemiBold_24)
                    }
                    .padding(.vertical, 20)

                    SettingListView(isLogoutAlert: $isLogoutAlert, isSignoutAlert: $isSignoutAlert)
                }
            }
            
            if isLogoutAlert {
                
                ZStack{
                    // 배경화면
                    Color.gray.opacity(0.4).edgesIgnoringSafeArea(.all)

                    CustomAlertView(
                        title: "로그아웃",
                        message: "로그아웃 하시겠습니까?",
                        leftButtonTitle: "취소",
                        leftButtonAction: { isLogoutAlert = false},
                        rightButtonTitle: "확인",
                        rightButtonAction: {
                            // MARK: - 로그아웃 처리
                            login = false
                            UserDefaults.standard.removeObject(forKey: "user_name")
                            UserDefaults.standard.removeObject(forKey: "user_UID")
                            UserDefaults.standard.removeObject(forKey: "user_profile_url")
                            UserDefaults.standard.synchronize()
                            profileViewModel.profileImage = Image("user")
                            profileViewModel.downloadImageFromProfileURL()
                            presentationMode.wrappedValue.dismiss()
                        })
                }
            }
                
        }
        .fullScreenCover(isPresented: $isSignoutAlert, content: {
            AccountDeleteView(isSignoutAlert: $isSignoutAlert)
        })
        .animation(.easeInOut(duration: 0.1), value: isLogoutAlert)
        
    }
}

#Preview {
    SettingView()
}
