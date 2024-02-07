//
//  profileViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/01.
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class ProfileViewModel: ObservableObject {
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String?
    
    private var userUIImage: UIImage? = nil
    var user: AuthDataResult?
    
    func isValidName() -> String {
        let regex = #"^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣_-]{2,20}$"#
        
        // 문자열 길이 체크
        if userName.count < 2 || userName.count > 20 {
            return "2에서 20자 사이여야 합니다."
        }
        
        // 정규 표현식 체크
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: userName) {
            return "한글, 영어, 숫자, -, _ 문자만 사용해야 합니다."
        }
        
        // TODO: - DB에서 중복되는 닉네임 확인
        return "success"
    }
    
    enum ImageState {
        case empty, loading(Progress), success(Image), failure(Error)
    }
    
    @Published var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        print("picture loading")
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else { return }
                switch result {
                case let .success(data?):
                    guard let uiImage = UIImage(data: data) else {
                        self.imageState = .empty
                        return
                    }
                    // MARK: - photospicker -> success 후 이미지 업로드
                    self.uploadImageToFirebase(image: uiImage)
                    self.imageState = .success(Image(uiImage: uiImage))
                    print("success Image selection")
                    
                case .success(.none):
                    self.imageState = .empty
                    // 기본이미지 넣기
                case let .failure(error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    
    // MARK: - Firebase 업로드
    func uploadUserInfoToFirebase() {
        print("saving")
        Task {
            do {
                let user = tempUser(userName: self.userName, userUID: self.userUID, userImageURL: self.userProfileURL)
                
                let _ = try Firestore.firestore().collection("Users").document(self.userUID).setData(from: user) { error in
                    if error == nil {
                        print("Saved Successfully")
                        print(user)
                        UserDefaults.standard.set(true, forKey: "Login")
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func uploadImageToFirebase(image: UIImage) {
        print(self.userUID)
        
        Task {
            do {
                // Storage에 DefaultProfile 이미지 저장
                guard let imageData = image.pngData() else { return }
                let storageRef = Storage.storage().reference().child("Profile_Images").child(self.userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                
                let downloadURL = try await storageRef.downloadURL()
               
                DispatchQueue.main.async {
                    self.userProfileURL = downloadURL.absoluteString
                    print("success downloadingURL", self.userProfileURL!)
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    
}
