//
//  CustomAlertButton.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI

struct LogoutAlertView: View {
    @AppStorage("Login") private var login: Bool = false
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("로그아웃")
                .font(.pretendardMedium_22)
                .padding(.bottom, 20)
            
            Text("로그아웃 하시겠습니까?")
                .font(.pretendardMedium_18)
                .foregroundColor(Color.gray)
            
            Spacer()
            
            HStack(spacing: 0) {
                Button {
                    showAlert = false
                } label: {
                    Text("취소")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width/2-30, height: 50)
                        .background(Color.btnGray)
                }
                
                Button {
                    // MARK: - 로그아웃 처리
                    login = false
                    UserDefaults.standard.removeObject(forKey: "user_name")
                    UserDefaults.standard.removeObject(forKey: "user_UID")
                    UserDefaults.standard.removeObject(forKey: "user_profile_url")
                    profileViewModel.downloadImageFromProfileURL()
                    
                    
                } label: {
                    Text("확인")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width/2-30, height: 50)
                        .background(Color.customGreen)
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width-60, height: 170)
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    LogoutAlertView(showAlert: .constant(false))
}
