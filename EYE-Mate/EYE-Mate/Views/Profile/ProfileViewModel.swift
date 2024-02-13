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
    
    
    // MARK: - photospicker -> success 후 이미지 저장, userProfileURL도 저장
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
                    
                    self.uploadImageToStorage(image: uiImage) // 이미지 업로드 후 userProfileURL 까지 저장 완료
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
    
    
    // MARK: - Firebase 업로드
    func uploadUserInfoToFirebase() {
        Task {
            do {
                let user = tempUser(userName: self.userName, userUID: self.userUID, userImageURL: self.userProfileURL)
                
                let _ = try Firestore.firestore().collection("Users").document(self.userUID).setData(from: user) { error in
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
    
    // MARK: - 프로필 이미지 변경시 이미지 업로드
    @MainActor
    func uploadImageToStorage(image: UIImage) {
        Task {
            do {
                // Storage에 DefaultProfile 이미지 저장
                guard let imageData = image.pngData() else { return }
                let storageRef = Storage.storage().reference().child("Profile_Images").child("\(self.userUID).png")
                let _ = try await storageRef.putDataAsync(imageData)
                
                let downloadURL = try await storageRef.downloadURL()
                
                DispatchQueue.main.async {
                    self.userProfileURL = downloadURL.absoluteString
                    print("success update Storage Image", self.userProfileURL)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - 로그인 된 상태의 profile 이미지를 위한 함수 -> 이미지 제공
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
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
    }
}
