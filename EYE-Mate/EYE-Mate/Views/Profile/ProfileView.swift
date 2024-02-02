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
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        // TODO: 로그인 상태이면 로그아웃 버튼 보여주고
        
        if loggedIn {
            VStack {
                Button {
                    self.logOutUser()
                    UserDefaults.standard.set(loggedIn, forKey: "Login")
                } label: {
                    Text("로그아웃")
                        .foregroundStyle(.white)
                        .font(.pretendardSemiBold_18)
                        .background(RoundedRectangle(cornerRadius: 10.0)
                            .foregroundStyle(Color.customGreen)
                            .frame(width: 300, height: 50))
                }
                .frame(width: 300, height: 50)
                .padding(.top, 30)
            }
        } else {
            LoginView()
        }
        

    }
    
    // MARK: Logging User Out
    func logOutUser() {
        try? Auth.auth().signOut()
        loggedIn = false
    }
}

#Preview {
    ProfileView()
}
