//
//  OTPViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/31.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    static let shared = LoginViewModel()
    var verificationID: String
    var user: AuthDataResult?

    @AppStorage("user_UID") private var userUID: String = "defaultImage"
    
    init( verificationID: String = "temp") {
        self.verificationID = verificationID
        UserDefaults.standard.set(false, forKey: "Login")
        
    }
    
    func sendVerificationCode(phoneNumber: String) {
        print(phoneNumber)
        // reCAPTCHA 기능 중지 - simulator용
//        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
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
    
    @MainActor
    // MARK: - signUpFlag == false 이고 storage에 uid 가 없으면 로그인 X -> 회원가입으로 유도(나중에)
    func verifyOTP(otp: String, signUpFlag: Bool, completion: @escaping (Bool) -> Void){
        // 인증 코드, 인증 ID를 사용해 FIRPhoneAuthCredential 객체 생성
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: otp)
        
        // credential 객체로 signin(로그인, 회원가입)
        Auth.auth().signIn(with: credential) { user, error in
            if let error = error {
                UserDefaults.standard.set(false, forKey: "Login")
                print(error.localizedDescription)
                completion(false)
            } else {
                // 인증번호 성공
                
                // if signUpFlag가 아니면 이 과정이 로그인 맞음
                self.userUID = user?.user.uid ?? "N/A" // UID 저장
                print("OTP Verify Success = \(user?.user.uid ?? "N/A")")
                completion(true)
            }
        }
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
