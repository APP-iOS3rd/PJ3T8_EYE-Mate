//
//  modalView.swift
//  NaverMapDemo
//
//  Created by 이민영 on 2024/01/29.
//

import SwiftUI
import FirebaseAuth
import Combine
import UIKit

enum SignUpErrorText: String {
    case otp = "인증번호 숫자 6자리를 다시 입력해주세요"
    case signup = "가입되지 않은 번호입니다.\n회원가입으로 계정을 만들어보세요!"
    case notiLogin = "이미 가입된 회원입니다.\n로그인 페이지를 이용해주세요!"
}

struct OTPVerificationView: View {
    @EnvironmentObject var router: Router
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @Binding var signUpFlag: Bool
    @FocusState.Binding var keyFocused: Bool
    @State private var otp: String = ""
    @State private var isDisplayotpErrorText: Bool = false
    @State var isDisplaySignUpText: Bool = false
    @State var isDisplayNotiLoginText: Bool = false
    @State private var errorText: String = ""
    
    var mobileNumber: String = ""
    var foregroundColor: Color = Color(.black)
    var backgroundColor: Color = Color(.systemGray6)
    
    // userdefaults login
    @AppStorage("Login") var loggedIn: Bool = false
    
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10){
            Text("인증번호")
                .font(.pretendardMedium_16)
            
            
            VStack(alignment:.leading, spacing: 10) {
                
                TextField("", text: $otp)
                    .font(.pretendardMedium_16)
                    .placeholder(when: otp.isEmpty) {
                        Text("Enter OTP")
                            .foregroundColor(.warningGray)
                            .font(.pretendardSemiBold_16)
                    }
                    .padding(10)
                    .focused($keyFocused)
                    .keyboardType(.numberPad)
                    .frame(width: 300, height: 50)
                    .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                if isDisplayotpErrorText || isDisplaySignUpText || isDisplayNotiLoginText {
                    Text(errorText)
                        .modifier(TextModifier())
                } else {
                    Text("")
                        .modifier(TextModifier())
                }
            }
            .animation(.easeInOut(duration: 0.6), value: keyFocused)
            
            // MARK: - 회원가입/로그인 버튼
            Button {
                Task{
                    do {
                        let success = try await loginViewModel.verifyOTP(otp: otp, signUpFlag: signUpFlag)
                        
                        if success {
                            isDisplayotpErrorText = false
                            
                            // 회원가입 화면
                            if signUpFlag {
                                isDisplaySignUpText = false
                                // 이미 등록된 회원인 경우 로그인 화면으로
                                if try await loginViewModel.checkLoginList() {
                                    isDisplayNotiLoginText = true
                                    errorText = SignUpErrorText.notiLogin.rawValue
                                } else {
                                    // 회원가입
                                    isDisplayNotiLoginText = false
                                    router.navigate(to: .signUpProfile)
                                }
                            }
                            // 로그인 화면인 경우
                            else {
                                let isRegistered = try await loginViewModel.checkLoginAndSettingInfo()
                                // 가입한 이력이 있는 경우
                                if isRegistered {
                                    loggedIn = true
                                    isDisplaySignUpText = false
                                    router.navigateBack()
                                }
                                // 가입한 이력이 없는 경우
                                else {
                                    loggedIn = false
                                    isDisplaySignUpText = true
                                    errorText = SignUpErrorText.signup.rawValue
                                }
                            }
                        } else {
                            isDisplayotpErrorText = true
                            errorText = SignUpErrorText.otp.rawValue
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
                
            } label: {
                Text(signUpFlag ? "회원가입" : "로그인")
                    .foregroundStyle(.white)
                    .font(.pretendardSemiBold_18)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.customGreen)
                        .frame(width: 300, height: 50))
            }
            .frame(width: 300, height: 50)
            .padding(.top, 10)
            .disableWithOpacity(otp.count < 6)
            .disabled(otp.count < 6)
        }
    }
}

fileprivate struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.pretendardMedium_16)
            .foregroundStyle(Color.customRed)
            .frame(width: 300, height: 40)
            .multilineTextAlignment(.center)
    }
}

//#Preview {
//    OTPVerificationView(loginViewModel: LoginViewModel(verificationID: "123"), signUpFlag: .constant(true))
//}
