//
//  LoginView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/31.
//

import SwiftUI

struct LoginView: View {
    @State var signUpFlag: Bool = false
    // Alert를 통해 들어왔는지 확인
    @Binding var isAlertView: Bool
    
    var type: LoginCase = .VisionTestViewModel
    
    // Login 여부를 파악해야 하는 ViewModels
    @ObservedObject var visionTestViewModel = VisionTestViewModel.shared
    
    // TODO: - loggedin에 따라 프로필/로그인 뷰 나올지 구현
    var body: some View {
        NavigationStack {
            ScrollView {
                if !isAlertView {
                    CustomBackButton()
                } else {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isAlertView.toggle()
                            switch type {
                            case .VisionTestViewModel:
                                visionTestViewModel.showFullScreenCover.toggle()
                            case .ColorTestViewModel:
                                break
                            case .AstigmatismTestViewModel:
                                break
                            case .SightTestViewModel:
                                break
                            }
                        }, label: {
                            Image("close")
                        })
                    }
                    .padding(.trailing)
                }
                if signUpFlag {
                    SignUpView(signUpFlag: $signUpFlag, isAlertView: $isAlertView)
                }
                else {
                    SignInView(signUpFlag: $signUpFlag, isAlertView: $isAlertView)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

enum LoginCase {
    case VisionTestViewModel, ColorTestViewModel, AstigmatismTestViewModel, SightTestViewModel
    // 앞으로 추가....
}
#Preview {
    LoginView(isAlertView: .constant(true))
}
