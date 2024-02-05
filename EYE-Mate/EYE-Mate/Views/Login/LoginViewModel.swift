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
    static let shared = LoginView()
    
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("user_profile_url") private var profileURL: URL?
    
    var verificationID: String
    init(verificationID: String) {
        self.verificationID = verificationID
        UserDefaults.standard.set(false, forKey: "Login")
        
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
                // 테스트 코드
                guard let uid = user?.user.uid else {return}
                Task {
                    do {
                        // Storage에 DefaultProfile 이미지 저장
                        guard let imageData = UIImage(named: "defaultprofile")?.pngData() else { return }
                        let storageRef = Storage.storage().reference().child("Profile_Images").child(uid)
                        let _ = try await storageRef.putDataAsync(imageData)
                        
                        let downloadURL = try await storageRef.downloadURL()
                        
                        let user = User(username: "TestAccount", userUID: uid, userImageURL: downloadURL)

                        let _ = try Firestore.firestore().collection("Users").document(uid).setData(from: user) { error in
                            if error == nil {
                                print("Saved Successfully")
                                self.userName = "TestAccount"
                                self.userUID = uid
                                self.profileURL = downloadURL
                            }
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
                
                UserDefaults.standard.set(true, forKey: "Login")
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
