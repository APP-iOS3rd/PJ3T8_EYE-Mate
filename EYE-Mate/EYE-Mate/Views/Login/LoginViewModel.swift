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
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    @AppStorage("Login") var loggedIn: Bool = false
    
    // TODO: - firestore 객체 하나로 통일
    //    let db = Firestore.firestore()
    
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
    
    // MARK: - 번호, 인증코드 일치 확인 후 토큰 생성
    @MainActor
    func verifyOTP(otp: String, signUpFlag: Bool) async throws -> Bool {
        // 인증 코드, 인증 ID를 사용해 FIRPhoneAuthCredential 객체 생성
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: otp)
        
        do {
            // credential 객체로 signin(로그인, 회원가입)
            let userCredential = try await Auth.auth().signIn(with: credential)
            // 인증번호 성공
            self.userUID = userCredential.user.uid // UID 저장
            print("OTP Verify Success = \(userCredential.user.uid)")
            return true
        } catch {
            UserDefaults.standard.set(false, forKey: "Login")
            print(error.localizedDescription)
            return false
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
    
    // MARK: - 로그인 할 때 회원목록에서 확인 및 회원정보 세팅
    @MainActor
    func checkLoginAndSettingInfo() async throws -> Bool{
        do {
            let querySnapshot = try await Firestore.firestore().collection("Users").getDocuments()
            // for문 으로
            for document in querySnapshot.documents {
                let data = document.data()
                if data["userUID"] as! String == userUID {
                    userName = data["userName"] as! String
                    userProfileURL = data["userImageURL"] as! String
                    profileViewModel.downloadImageFromProfileURL()
                    return true
                }
            }
        } catch {
            print("Error getting document: \(error)")
            throw error
        }
        return false
    }
    
    
    // MARK: - 회원가입 시 회원 정보가 이미 있는 경우 -> 로그인으로 안내할 것
    @MainActor
    func checkLoginList() async throws -> Bool{
        do {
            let querySnapshot = try await Firestore.firestore().collection("Users").getDocuments()
            // for문 으로
            for document in querySnapshot.documents {
                let data = document.data()
                if data["userUID"] as! String == userUID {
                    return true
                }
            }
        } catch {
            print("Error getting document: \(error)")
            throw error
        }
        return false
    }
    
}
