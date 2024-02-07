//
//  PostViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/6/24.
//

import SwiftUI

import FirebaseFirestore
import FirebaseStorage

class PostViewModel: ObservableObject {
    @Published var post: Post
    
    @Published var commentText: String = "댓글을 남겨보세요..."
    @Published var commentPlaceHolder: String = "댓글을 남겨보세요..."
    
    @Published var isLoading: Bool = false
    
    @State private var docListener: ListenerRegistration?
    
    @AppStorage("user_UID") private var userUID: String = ""
    
    init(post: Post) {
        self.post = post
    }
    
    /// - Document Listener 추가
    func addDocListener(completion: @escaping (Post?) -> ()) {
        if docListener == nil {
            guard let postID = post.id else { return }
            docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot, error in
                if let snapshot {
                    if snapshot.exists {
                        if let updatedPost = try? snapshot.data(as: Post.self) {
                            // 변경 사항 있으면 수정
                            completion(updatedPost)
                        }
                    } else {
                        // 게시물 없으면 삭제
                        completion(nil)
                    }
                }
            })
        }
    }
    
    /// - 좋아요 버튼 Action
    func likePost() {
        Task {
            guard let postID = post.id else { return }
            if post.likedIDs.contains(userUID) {
                // 배열에서 사용자 ID 제거
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            } else {
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    /// - 게시물 삭제 Action
    func deletePost() {
        isLoading = true
        Task {
            do {
                // 게시물 이미지 삭제
                if let imageReferenceIDs = post.imageReferenceIDs {
                    for imageReferenceID in imageReferenceIDs {
                        try await Storage.storage().reference().child("Post_Images").child(imageReferenceID).delete()
                    }
                }
                
                // 게시물 삭제
                guard let postID = post.id else { return }
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
