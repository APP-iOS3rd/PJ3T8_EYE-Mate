//
//  OTPViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/31.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    
    var verificationID: String
    init(verificationID: String) {
        self.verificationID = verificationID
    }
    
    func sendVerificationCode(phoneNumber: String) {
        print(phoneNumber)
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let verificationID = verificationID {
                    print("verificationID:", verificationID)
                    self.verificationID =  verificationID
                }
            }
    }
    
    
    func verifyOTP(otp: String) -> Bool{
        var errorFlag: Bool = false
        // 인증 코드, 인증 ID를 사용해 FIRPhoneAuthCredential 객체 생성
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: otp)
        
        // credential 객체로 signin(로그인, 회원가입)
        Auth.auth().signIn(with: credential) { user, error in
            print(user?.user.uid ?? "Nope")
            errorFlag = true
            if let error = error {
                print(error.localizedDescription)
            } else {

                print("OTP Verify Success = \(user?.user.uid ?? "N/A")")
            }
        }
        return errorFlag
    }
    
    func resendOTP(mobileNumber: String) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(mobileNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if verificationID != nil {
                    print("Code has been resent!")
                    
                }
            }
    }
}
