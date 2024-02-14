//
//  modalView.swift
//  NaverMapDemo
//
//  Created by 이민영 on 2024/01/29.
//

import SwiftUI
import FirebaseAuth
import Combine


struct OTPVerificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @ObservedObject var loginViewModel = LoginViewModel.shared

    @Binding var signUpFlag: Bool
    @State private var otp: String = ""
    @State private var isDisplayotpErrorText: Bool = false
    @State var isDisplayProfileSettingView: Bool = false
    @State var isDisplaySignUpText: Bool = false
    @State var isDisplayNotiLoginText: Bool = false
    
    @FocusState private var keyIsFocused: Bool
    
    var mobileNumber: String = ""
    var foregroundColor: Color = Color(.black)
    var backgroundColor: Color = Color(.systemGray6)
    
    // userdefaults login
    @AppStorage("Login") var loggedIn: Bool = false
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading, spacing: 10){
                Text("인증번호")
                    .font(.pretendardMedium_16)
                
                VStack(alignment:.leading, spacing: 0) {
                    
                    TextField("", text: $otp)
                        .font(.pretendardMedium_16)
                        .placeholder(when: otp.isEmpty) {
                            Text("Enter OTP")
                                .foregroundColor(.warningGray)
                                .font(.pretendardSemiBold_16)
                                .focused($keyIsFocused)
                        }
                        .padding(10)
                        .keyboardType(.numberPad)
                        .frame(width: 300, height: 50)
                        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                    
                    if isDisplayotpErrorText {
                        Text("인증번호 숫자 6자리를 다시 입력해주세요")
                            .modifier(TextModifier())
                    }
                    
                    if isDisplaySignUpText {
                        Text("가입되지 않은 번호입니다.\n회원가입으로 계정을 만들어보세요!")
                            .modifier(TextModifier())
                    }
                    
                    if isDisplayNotiLoginText {
                        Text("이미 가입된 회원입니다.\n로그인 페이지를 이용해주세요!")
                            .modifier(TextModifier())
                    }
                }
                
                // MARK: - 회원가입/로그인 버튼
                Button {
                    // MARK: - loginViewModel에서 로그인이면 정보 가져와야함
                    loginViewModel.verifyOTP(otp: otp, signUpFlag: signUpFlag) { success in
                        if success {
                            isDisplayotpErrorText = false
                            
                            // 회원가입 화면
                            if signUpFlag {
                                isDisplaySignUpText = false
                                Task{
                                    // 이미 등록된 회원인 경우 -> 로그인 화면으로 유도
                                    if try await loginViewModel.checkLoginList() {
                                        isDisplayNotiLoginText = true
                                        isDisplayProfileSettingView = false
                                    } else {
                                    // 정상적인 회원가입 프로세스
                                        isDisplayNotiLoginText = false
                                        isDisplayProfileSettingView = true
                                    }
                                }
                                
                            // 로그인 화면인 경우
                            } else {
                                Task{
                                    let isRegistered = try await loginViewModel.checkLoginAndSettingInfo()
                                    if isRegistered { // 가입한 이력이 있는 경우
                                        loggedIn = true
                                        isDisplaySignUpText = false
                                        profileViewModel.downloadImageFromProfileURL()
                                        presentationMode.wrappedValue.dismiss()
                                    } else { // 가입한 이력이 없는 경우
                                        loggedIn = false
                                        isDisplaySignUpText = true
                                    }
                                }
                            }
                            
                        } else {
                            isDisplayotpErrorText = true
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
                .padding(.top, 30)
                .disableWithOpacity(otp.count < 6)
            }
            
        }
        .navigationDestination(isPresented: $isDisplayProfileSettingView){
            SignUpProfileView()
        }
    }
}

fileprivate struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.pretendardMedium_16)
            .foregroundStyle(Color.customRed)
            .frame(width: 300, height: 50)
    }
}

#Preview {
    OTPVerificationView(loginViewModel: LoginViewModel(verificationID: "123"), signUpFlag: .constant(true))
}
