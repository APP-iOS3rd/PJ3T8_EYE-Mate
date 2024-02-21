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
    
    // 수정할 게시물 Data
    var post: Post?
    
    // 게시물의 이미지를 수정했는지에 대한 flag
    var editingPostImages: Bool = false
    
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
    
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
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
                    print("게시물 수정 - 이미지 추가")
                    isLoading = false
                    photoItem = []
                    editingPostImages = true
                }
            }
        }
    }
    
    /// - 이미지 삭제 함수
    func removeImage(at index: Int) {
        // 인덱스가 유효한지 확인
        guard index >= 0 && index < postImageDatas.count else {
            return // 유효하지 않은 인덱스이므로 함수 종료
        }
        
        postImageDatas.remove(at: index)
        print("게시물 수정 - 이미지 삭제")
        editingPostImages = true
    }
    
    /// - 게시물 업로드
    func createPost(completion: @escaping (Post) -> ())  {
        isLoading = true
        Task {
            do {
                // 이미지 업로드(있는경우)
                if !postImageDatas.isEmpty {
                    let imageUrls = try await uploadImagesToFirebaseStorage()
                    
                    let post = Post(postTitle: postTitle,
                                    postContent: postContent,
                                    postImageURLs: imageUrls.imageDownloadURLs,
                                    imageReferenceIDs: imageUrls.imageReferenceIDs ,
                                    userName: userName,
                                    userUID: userUID,
                                    userImageURL: userProfileURL)
                    
                    try await createDocumentAtFirebase(post) {
                        completion($0)
                    }
                } else { // 업로드할 이미지 없는 경우
                    let post = Post(postTitle: postTitle, postContent: postContent, userName: userName, userUID: userUID, userImageURL: userProfileURL)
                    
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
                completion(updatedPost)
            }
        }
    }
    
    /// - 게시물 수정
    func editPost(completion: @escaping (String, String, String, [URL]?, [String]?) -> ()) {
        isLoading = true
        Task {
            do {
                guard let post = post, let postID = post.id else { return }
                
                // Images 변경 사항 있을 시 Storage의 기존 image 삭제
                if editingPostImages {
                    // 이미지를 추가한 경우
                    if !postImageDatas.isEmpty {
                        let imageUrls = try await uploadImagesToFirebaseStorage()
                        
                        // Storage 기존 이미지 삭제
                        if let imageReferenceIDs = post.imageReferenceIDs {
                            for imageReferenceID in imageReferenceIDs {
                                try await Storage.storage().reference().child("Post_Images").child(imageReferenceID).delete()
                            }
                        }
                        
                        // Firestore Post에 새로운 이미지 업데이트
                        let stringImageDownloadURLs = imageUrls.imageDownloadURLs.map { $0.absoluteString }
                        
                        try await Firestore.firestore().collection("Posts").document(postID).updateData([
                            "postImageURLs" : stringImageDownloadURLs,
                            "imageReferenceIDs" : imageUrls.imageReferenceIDs
                        ])
                        
                        await MainActor.run {
                            completion(postID,
                                       self.postTitle,
                                       self.postContent,
                                       imageUrls.imageDownloadURLs,
                                       imageUrls.imageReferenceIDs)
                        }
                    } else {
                        // Storage 기존 이미지 삭제
                        if let imageReferenceIDs = post.imageReferenceIDs {
                            for imageReferenceID in imageReferenceIDs {
                                try await Storage.storage().reference().child("Post_Images").child(imageReferenceID).delete()
                            }
                        }
                        
                        // 이미지를 추가하지 않은 경우
                        try await Firestore.firestore().collection("Posts").document(postID).updateData([
                            "postImageURLs" : FieldValue.delete(),
                            "imageReferenceIDs" : FieldValue.delete()
                        ])
                        
                        await MainActor.run {
                            completion(postID,
                                       self.postTitle,
                                       self.postContent,
                                       nil,
                                       nil)
                        }
                    }
                } else {
                    // 이미지 변경 사항이 없는 경우
                    try await Firestore.firestore().collection("Posts").document(postID).updateData([
                        "postTitle" : self.postTitle,
                        "postContent" : self.postContent
                    ])
                    
                    await MainActor.run {
                        completion(postID,
                                   self.postTitle,
                                   self.postContent,
                                   post.postImageURLs,
                                   post.imageReferenceIDs)
                    }
                }
            } catch {
                print("CreateNewPostViewModel - editPost() : \(error.localizedDescription)")
            }
        }
    }

    
    /// - Storage Image URL을 Data로 변환하여 postImageDatas에 추가
    func loadImage(from urls: [URL]) {
        isLoading = true
        Task {
            do {
                for url in urls {
                    let data = try await loadData(from: url)
                    await MainActor.run {
                        postImageDatas.append(data)
                    }
                }
                
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }

    /// - Storage Image URL을 Data로 변환
    func loadData(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

}
