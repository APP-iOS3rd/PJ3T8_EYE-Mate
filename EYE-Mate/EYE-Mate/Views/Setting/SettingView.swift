//
//  Account.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("Login") private var login: Bool = false
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    CustomBackButton()
                    
                    VStack(spacing: 20) {
                        profileViewModel.profileImage
                            .ProfileImageModifier()
                            .frame(width: 200, height: 200)
                        
                        Text(userName)
                            .font(.pretendardSemiBold_24)
                    }
                    .padding(.vertical, 50)
                    
                    SettingListView(profileViewModel: profileViewModel, showAlert: $showAlert)
                }
            }
            
            if showAlert {
                ZStack{
                    // 배경화면
                    Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                    
                    CustomAlertView(
                        showAlert: $showAlert,
                        title: "로그아웃",
                        message: "로그아웃 하시겠습니까?",
                        leftButtonTitle: "취소",
                        leftButtonAction: { showAlert = false},
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
    }
}

#Preview {
    SettingView(profileViewModel: ProfileViewModel())
}
