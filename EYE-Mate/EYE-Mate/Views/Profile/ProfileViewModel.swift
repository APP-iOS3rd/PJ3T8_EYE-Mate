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
    static let shared = ProfileViewModel()
    
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = "https://firebasestorage.googleapis.com/v0/b/eye-mate-29855.appspot.com/o/Profile_Images%2FdefaultImage.png?alt=media&token=923656d8-3cd8-4098-b5aa-3628770e0256"

    @Published var profileImage: Image = Image("user")
    
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
        case empty(Image), loading(Progress), success(Image), failure(Error)
    }
    
    @Published var imageState: ImageState = .empty(Image("test"))
    
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty(profileImage)
            }
        }
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
                        self.imageState = .empty(self.profileImage)
                        return
                    }

                    self.uploadImageToStorage(image: uiImage) // 이미지 업로드 후 downloadURL 까지 저장 완료
                    self.imageState = .success(Image(uiImage: uiImage))
                    self.profileImage = Image(uiImage: uiImage)
                    print("success Image selection")
                    
                case .success(.none):
                    self.imageState = .empty(self.profileImage)
                    // 기본이미지 넣기
                case let .failure(error):
                    self.imageState = .failure(error)
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
    
    
    func uploadImageToStorage(image: UIImage) {
        print(self.userUID)
        
        Task {
            do {
                // Storage에 DefaultProfile 이미지 저장
                guard let imageData = image.pngData() else { return }
                let storageRef = Storage.storage().reference().child("Profile_Images").child("\(self.userUID).png")
                let _ = try await storageRef.putDataAsync(imageData)
                
                let downloadURL = try await storageRef.downloadURL()
               
                DispatchQueue.main.async {
                    self.userProfileURL = downloadURL.absoluteString
                    print("success downloadingURL", self.userProfileURL)
                }
                
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func downloadImageToFirebase() {
        // default image는 uid = defaultImage
        print(self.userUID)
        Task {
            do {
                // Storage에서 이미지 가져오기
                let storageRef = Storage.storage().reference().child("Profile_Images").child("\(self.userUID).png")
                
                let downloadURL = try await storageRef.downloadURL()
                
                DispatchQueue.main.async {
                    self.userProfileURL = downloadURL.absoluteString
                    print("success downloadingURL", self.userProfileURL)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - 로그인 된 상태의 profile 이미지를 위한 함수 -> 이미지 제공
    func downloadImageFromProfileURL() -> Image {
        var downloadImage: Image = Image("user")
        
        // uid가 저장 안된 기본 상태일 때는 기본 이미지 제공
        guard let imageURL = URL(string: userProfileURL) else {
            print("Invalid image URL")
            return downloadImage // 기본 이미지
        }
        
        // 비동기적으로 이미지 다운로드
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // UIImage로 변환
            if let uiImage = UIImage(data: data) {
                // SwiftUI Image로 변환하여 UI 업데이트를 메인 스레드에서 수행
                print("프로필url에서 이미지를 가져왔습니다")
                DispatchQueue.main.async {
                    downloadImage = Image(uiImage: uiImage)
                }
            } else {
                print("이미지를 UIImage로 변환할 수 없습니다.")
            }
        }.resume()
        
        return downloadImage
    }
    
    
}
