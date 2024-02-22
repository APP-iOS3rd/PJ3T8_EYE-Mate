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
import Kingfisher

class ProfileViewModel: ObservableObject {
    static let shared = ProfileViewModel()
    
    @Published var isPresentedProfileView = false
    
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    
    @Published var profileImage: Image = Image("user")
    
    let db = Firestore.firestore()
    
    init() {
        downloadImageFromProfileURL()
    }
    
    enum ImageState {
        case empty, loading(Progress), success, failure(Error)
    }
    
    @Published var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection = imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    // MARK: - userName 조건 확인
    func isValidName(_ userName: String) async throws -> (Bool, Bool) {
        let regex = #"^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣_-]{2,20}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        var result = (false, false)
        
        // 문자열 길이, 정규 표현식 체크
        if userName.count < 2 || userName.count > 20 || !predicate.evaluate(with: userName) {
            result.0 = true
        }
        // 중복 이름 체크
        if try await !checkNameList(textName: userName) {
            result.1 = true
        }
        
        return result
    }
    
    // MARK: - DB에 중복되는 닉네임 체크
    func checkNameList(textName: String) async throws -> Bool{
        let query = db.collection("Users").whereField("userName", isEqualTo: textName)
        
        do {
            let querySnapshot = try await query.getDocuments()
            let documents = querySnapshot.documents
            
            if !documents.isEmpty {
                for document in documents {
                    if document.documentID != self.userUID {
                        print("The name already exists")
                        return false
                    }
                }
                return true
                
            } else {
                print("No documents found")
                return true
            }
            
        }
}
        
        // MARK: - 닉네임 변경 - firestore update 함수
        func updateNameToFirebase() {
            let documentRef = db.collection("Users").document(self.userUID)
            documentRef.updateData(["userName": self.userName]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Username successfully updated")
                }
            }
        }
        
        // MARK: - photospicker -> success 후 이미지 저장, userProfileURL도 저장
        private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
            return imageSelection.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async {
                    guard imageSelection == self.imageSelection else { return }
                    switch result {
                    case let .success(data?):
                        guard let uiImage = UIImage(data: data) else {
                            self.imageState = .empty
                            return
                        }
                        
                        self.updateImageToStorage(image: uiImage) // 이미지 업로드 후 userProfileURL 까지 저장 완료
                        self.imageState = .success
                        self.profileImage = Image(uiImage: uiImage)
                        
                    case .success(.none):
                        self.imageState = .empty
                        
                        // 기본이미지 넣기
                    case let .failure(error):
                        self.imageState = .failure(error)
                        self.profileImage = Image(systemName: "exclamationmark.triangle.fill")
                    }
                }
            }
        }
        
        
        // MARK: - 회원가입 - Firebase user정보 업로드
        func uploadUserInfoToFirebase() {
            Task {
                do {
                    let user = User(userName: self.userName, userUID: self.userUID, userImageURL: self.userProfileURL, left: "", right: "")
                    
                    let _ = try db.collection("Users").document(self.userUID).setData(from: user) { error in
                        if error == nil {
                            print("Saved Successfully")
                            UserDefaults.standard.set(true, forKey: "Login")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        // MARK: - 프로필 이미지 변경 시 이미지 업로드
        @MainActor
        func updateImageToStorage(image: UIImage) {
            Task {
                do {
                    guard let imageData = image.pngData() else { return }
                    let storageRef = Storage.storage().reference().child("Profile_Images").child("\(self.userUID).png")
                    let _ = try await storageRef.putDataAsync(imageData)
                    
                    let downloadURL = try await storageRef.downloadURL()
                    // 회원가입시 기본 url로 firestore에 저장된 경우, 값 업데이트
                    if userProfileURL.contains("defaultImage.png") {
                        self.userProfileURL = downloadURL.absoluteString
                        updateImageURLToFirebase()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        // MARK: - 회원가입 후 이미지 변경을 안했다면, URL update to firebase
        func updateImageURLToFirebase() {
            let documentRef = db.collection("Users").document(self.userUID)
            documentRef.updateData(["userImageURL": self.userProfileURL]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("UserImageURL successfully updated", self.userProfileURL)
                }
            }
            
        }
        
        // MARK: - 로그인 된 상태에서 profileURL 이미지 다운 받는 함수
        func downloadImageFromProfileURL() {
            let downloader = ImageDownloader.default
            let processor = DownsamplingImageProcessor(size: CGSize(width: 300, height: 300))
            
            // uid가 저장 안된 기본 상태일 때는 기본 이미지 제공
            guard let imageURL = URL(string: self.userProfileURL) else {
                return print("Invalid image URL")
            }
            
            downloader.downloadImage(with: imageURL, options: [.processor(processor)]) { result in
                switch result {
                case .success(let value):
                    self.profileImage = Image(uiImage: value.image)
                    print("Current ImageURL:", self.userProfileURL)
                case .failure(let error):
                    print("Error downloading image: \(error)")
                }
            }
        }
    }
