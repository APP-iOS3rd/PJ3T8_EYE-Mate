//
//  LoginViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/26.
//

import Foundation
import FirebaseAuth
import SwiftUI

class LoginViewModel: ObservableObject {
    static let shared = LoginViewModel()
    


    func login(){
        print("login 시작")
        let phoneNumber = "+16505551234"

        // This test verification code is specified for the given test phone number in the developer console.
        let testVerificationCode = "654321"
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        print("auth")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate:nil) {
            (verificationID, error) in
            if error != nil {
                print("인증Error: \(error.debugDescription)")
                
                return
            }
            else if error == nil {
                print("nilnil")
            }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "",
                                                                     verificationCode: testVerificationCode)
            print("credential", credential)
            Auth.auth().signIn(with: credential) { (authData, error) in
                if error != nil {
                    print("로그인Error: \(error.debugDescription)")
                    
                    return
                }
                print("login 성공")
                print("authData: \(String(describing: authData))")
            }
        }
    }
   
}
