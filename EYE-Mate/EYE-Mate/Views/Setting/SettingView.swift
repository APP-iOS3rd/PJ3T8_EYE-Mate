//
//  Account.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI
import PhotosUI

struct SettingView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @AppStorage("user_name") private var userName: String = "EYE-Mate"

    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // TODO: back 버튼 추가
                        // setting view에서 변경하는 이미지는 -> firebase에도 반영해야함
                        profileViewModel.profileImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                        
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
                    LogoutAlertView(showAlert: $showAlert)
                }
            }
        }
    }
}

#Preview {
    SettingView(profileViewModel: ProfileViewModel())
}
