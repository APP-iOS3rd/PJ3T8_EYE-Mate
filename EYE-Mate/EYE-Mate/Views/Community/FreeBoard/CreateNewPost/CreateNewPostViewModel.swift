//  CreateNewPostViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/26/24.


import SwiftUI
import PhotosUI

import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class CreateNewPostViewModel: ObservableObject {
    @Published var post: Post?
    
    // 게시물 제목, 내용
    @Published var postTitle: String = ""
    @Published var postContent: String = ""
    
    // 선택된 사진
    @Published var postImageDatas: [Data] = []
    
    // PhotosPicker
    @Published var showImagePicker: Bool = false
    @Published var photoItem: [PhotosPickerItem] = []
    
    // 이미지 로딩 중임을 알리는 변수
    @Published var isLoading = false
    
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    
    /// 작성하기 버튼 활성 조건 get
    /// - true =  버튼 활성, false = 버튼 비활성
    func postButtonActive() -> Bool {
        return !postTitle.isEmpty && !postContent.isEmpty
    }
    
    /// - 게시물 Image 선택
    func addSelectedImages() {
        if !photoItem.isEmpty {
            Task {
                await MainActor.run {
                    isLoading = true
                }
                for item in photoItem {
                    if postImageDatas.count == 10 { break } // 사진 수 제한
                    if let imageData = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: imageData),
                       let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                        await MainActor.run {
                            //                            postImageDatas.append(ImageData(data: compressedImageData))
                            postImageDatas.append(compressedImageData)
                        }
                    }
                }
                await MainActor.run{
                    isLoading = false
                    photoItem = []
                }
            }
        }
    }
    
    /// - 이미지 삭제 함수
    func removeImage(at index: Int) {
        postImageDatas.remove(at: index)
    }
    
    /// - 게시물 업로드
    func createPost(completion: @escaping (Post) -> ())  {
        isLoading = true
        Task {
            do {
                guard let profileURL = profileURL else { return }
                
                // 이미지 업로드(있는경우)
                if !postImageDatas.isEmpty {
                    let imageUrls = try await uploadImagesToFirebaseStorage()
                    
                    let post = Post(postTitle: postTitle, 
                                    postContent: postContent,
                                    postImageURLs: imageUrls.imageDownloadURLs,
                                    imageReferenceIDs: imageUrls.imageReferenceIDs ,
                                    userName: userName,
                                    userUID: userUID,
                                    userImageURL: profileURL)
                    
                    try await createDocumentAtFirebase(post) {
                        completion($0)
                    }
                } else { // 업로드할 이미지 없는 경우
                    let post = Post(postTitle: postTitle, postContent: postContent, userName: userName, userUID: userUID, userImageURL: profileURL)
                    
                    try await createDocumentAtFirebase(post) {
                        completion($0)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// - Storage 게시물 이미지 업로드
    func uploadImagesToFirebaseStorage() async throws -> (imageReferenceIDs: [String] , imageDownloadURLs: [URL]) {
        let storageRef = Storage.storage().reference().child("Post_Images")
        
        return try await withThrowingTaskGroup(of: URL.self) { group in
            var imageDownloadURLs = [URL]()
            var imageReferenceIDs = [String]()
            
            for (index, imageData) in postImageDatas.enumerated() {
                let imageReferenceID = "\(self.userUID)\(Date())_\(index)"
                imageReferenceIDs.append(imageReferenceID)
                
                group.addTask(priority: .background) {
                    let imageRef = storageRef.child(imageReferenceID)

                    // Uploading image data to Firebase Storage
                    _ = try await imageRef.putDataAsync(imageData)
                    
                    // Getting download URL
                    let downloadURL = try await imageRef.downloadURL()
                    return downloadURL
                }
            }
            
            for try await imageUrl in group {
                imageDownloadURLs.append(imageUrl)
            }
            
            return (imageReferenceIDs, imageDownloadURLs)
        }
    }
    
    /// - Firestore 게시물 업로드
    func createDocumentAtFirebase(_ post: Post, completion: @escaping (Post) -> ()) async throws {
        // Firebase Firestore에 문서 쓰기
        let postDoc = Firestore.firestore().collection("Posts").document()
        
        // Posts Collection에 게시물 추가
        let _ = try postDoc.setData(from: post) { error in
            print("Firestore - Post Create Success")
            if error == nil {
                self.isLoading = false
                var updatedPost = post
                updatedPost.id = postDoc.documentID
                
                self.post = updatedPost
                completion(updatedPost)
            }
        }
    }
}
