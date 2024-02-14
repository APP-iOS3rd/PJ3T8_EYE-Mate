//
//  SignOutViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AccountDeleteViewModel: ObservableObject{
    static let shared = AccountDeleteViewModel()
    @Published var signoutContents: [SignOutContent]
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    @AppStorage("Login") var loggedIn: Bool = false
    
    init(signoutContents: [SignOutContent] = [
        .init(icon: "📊", title: "시력 검사 기록이 사라져요", subTitle: "EYE-Mate를 탈퇴하면 기록되어 관리되던 시력 검사 기록들이 모두 삭제되며, 복구할 수 없어요."),
        .init(icon: "📝", title: "게시판 정보가 사라져요", subTitle: "EYE-Mate를 탈퇴하면 작성한 게시판, 댓글, 저장한 게시글 등 관련 개인 기록이 삭제되며, 복구할 수 없어요."),
        .init(icon: "🔒", title: "시력 검사 기록이 사라져요", subTitle: "EYE-Mate를 탈퇴하면 기록, 게시판 기능 등 다시 회원가입을 해야 이용가능해요.")
    ]) {
        self.signoutContents = signoutContents
    }
    
    
    // userdefaults # 마지막에
    
    // auth 삭제
    func deleteUserFromAuth() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("Error deleting user: \(error.localizedDescription)")
                } else {
                    print("User deleted successfully.")
                }
                
            }
        }
    }
    
    func deleteUserImageFromStorage() {
        let storageRef = Storage.storage().reference()
        let fileName = "\(self.userUID).png"
        let filePath = "Profile_Images/\(fileName)"
        
        storageRef.child(filePath).delete { error in
            if let error = error {
                print("Error deleting file: \(error.localizedDescription)")
            } else {
                print("File deleted successfully.")
            }
        }
    }
    
    func deleteUserInfoFromStore() {
        let db = Firestore.firestore()
        
        db.collection("Users").document(self.userUID).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
            
        }
    }
    
    func deleteUserDefaults() {
        loggedIn = false
        UserDefaults.standard.removeObject(forKey: "user_name")
        UserDefaults.standard.removeObject(forKey: "user_UID")
        UserDefaults.standard.removeObject(forKey: "user_profile_url")
        profileViewModel.downloadImageFromProfileURL()
    }
    
}
