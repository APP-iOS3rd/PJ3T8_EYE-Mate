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
    @Binding var verificationID: String
    @State private var otp: String = ""
    @State private var otpErrorView: Bool = false
    @FocusState private var keyIsFocused: Bool
    var mobileNumber: String = ""
    var foregroundColor: Color = Color(.black)
    var backgroundColor: Color = Color(.systemGray6)
    @State private var loggedIn = UserDefaults.standard.bool(forKey: "Login")
    
    var body: some View {
        VStack(alignment:.leading, spacing: 10){
            Text("인증번호")
                .font(.pretendardMedium_16)
            
            VStack(alignment:.leading, spacing: 0) {
                
                TextField("", text: $otp)
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
                
                
                if otpErrorView {
                    Text("인증번호 숫자 6자리를 다시 입력해주세요")
                        .font(.pretendardMedium_16)
                        .foregroundStyle(Color.customRed)
                        .frame(width: 300, height: 50)
                }
            }
            
            Button {
                self.verifyOTP()
            } label: {
                Text("회원가입")
                    .foregroundStyle(.white)
                    .font(.pretendardSemiBold_18)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                        .foregroundStyle(Color.customGreen)
                        .frame(width: 300, height: 50))
            }
            .frame(width: 300, height: 50)
            .disableWithOpacity(otp.count < 6)
        }
    }
    
    private func verifyOTP() {
        if loggedIn {
            if let user = Auth.auth().currentUser {
                print("login:", user.uid)
            }
        } else {
            if let user = Auth.auth().currentUser {
                print("user:", user.uid)
            } else {
                print("No user in DB")
                // 인증 코드, 인증 ID를 사용해 FIRPhoneAuthCredential 객체 생성
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otp)
                
                // credential 객체로 signin(로그인)
                Auth.auth().signIn(with: credential) { user, error in
                    print(user?.user.uid ?? "Nope")
                    if let error = error {
                        print(error.localizedDescription)
                        self.otpErrorView = true
                    } else {
                        self.otpErrorView = false
                        self.loggedIn = true
                        UserDefaults.standard.set(self.loggedIn, forKey: "Login")
                        print("OTP Verify Success = \(user?.user.uid ?? "N/A")")
                    }
                }
            }
        }
        
    }
    
    func resendOTP() {
        print(mobileNumber)
        
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(mobileNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let verificationID = verificationID {
                    self.verificationID =  verificationID
                    print("Code has been resent!")
                    
                }
            }
    }
}

#Preview {
    OTPVerificationView(verificationID: .constant("123"))
}
