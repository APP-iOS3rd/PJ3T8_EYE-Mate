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
    func isValidName(_ userName: String) async throws -> String {
        var preName = ""
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
        
        if try await !checkNameList() {
            return "이미 사용 중인 닉네임입니다."
        }
        
        return "success"
    }
    
    // MARK: - DB에 중복되는 닉네임 체크
    func checkNameList() async throws -> Bool{
        let querySnapshot = try await db.collection("Users").getDocuments()
        
        // 닉네임 변경 - 원래의 닉네임을 입력 하면 중복 검사 제외
        let currentUserDocument = try await db.collection("Users").document(self.userUID).getDocument()
        var preName = "" // 현재 닉네임 넣어놓을 변수
        if let currentUserData = try? currentUserDocument.data(as: tempUser.self) {
            preName = currentUserData.userName
        }
        // 현재 닉네임을 제외한 닉네임 리스트
        let userNames = querySnapshot.documents.compactMap { try? $0.data(as: tempUser.self).userName }
        let nameLists = userNames.filter { $0 != preName }
        
        print(nameLists)
        if nameLists.contains(self.userName) {
            self.userName = preName
            return false
        }
        
        return true
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
                let user = tempUser(userName: self.userName, userUID: self.userUID, userImageURL: self.userProfileURL)
                
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
                
                self.userProfileURL = downloadURL.absoluteString
                print("success update Storage Image", self.userProfileURL)
                
                // 회원가입시 기본 url로 firestore에 저장된 경우, 값 업데이트
                if userProfileURL.contains("defaultImage.png") {
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
                print("UserImageURL successfully updated")
            }
        }
        
    }
    
    // MARK: - 로그인 된 상태에서 profileURL 이미지 다운 받는 함수
    func downloadImageFromProfileURL() {
        let downloader = ImageDownloader.default
        let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
        
        // uid가 저장 안된 기본 상태일 때는 기본 이미지 제공
        guard let imageURL = URL(string: userProfileURL) else {
            return print("Invalid image URL")
        }
        
        downloader.downloadImage(with: imageURL, options: [.processor(processor)]) { result in
            switch result {
            case .success(let value):
                self.profileImage = Image(uiImage: value.image)
                print(self.userProfileURL)
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }
}
