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
    
    @Published var isLoading: Bool = false
    
    @Published var commentText: String = ""
    @Published var commentPlaceholder: String = "댓글을 입력해보세요..."
    @Published var commentViewPadding: CGFloat = 15
    @Published var commentViewCornerRadius: CGFloat = 10
    
    @Published var newComment: Comment? // 새롭게 작성된 댓글
    @Published var newReplyComment: ReplyComment? // 새롭게 작성된 대댓글
    
    @Published var replyWritingCommentID: String? // 대댓글 작성중인 댓글의 댓글 ID
    @Published var replyWritingCommentIndex: Int? // 대댓글 작성중인 댓글의 댓글 Index
    
    @State private var docListener: ListenerRegistration?
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("user_profile_url") private var profileURL: URL?
    
    private let dbRef = Firestore.firestore().collection("Posts")
    
    init(post: Post) {
        self.post = post
    }
    
    /// - Document Listener 추가
    func addDocListener(completion: @escaping (Post?) -> ()) {
        if docListener == nil {
            guard let postID = post.id else { return }
            docListener = dbRef.document(postID).addSnapshotListener { snapshot, error in
                if let snapshot = snapshot, snapshot.exists {
                    if let updatedPost = try? snapshot.data(as: Post.self) {
                        completion(updatedPost)
                    }
                } else {
                    // 게시물이 삭제된 경우
                    completion(nil)
                }
            }
        }
    }
    
    /// - 좋아요 버튼 Action
    func likePost() {
        Task {
            guard let postID = post.id else { return }
            if post.likedIDs.contains(userUID) {
                // 배열에서 사용자 ID 제거
                try await dbRef.document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            } else {
                try await dbRef.document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    /// - docListener 제거
    func removeDocListener() {
        if let docListener {
            docListener.remove()
            self.docListener = nil
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
                try await dbRef.document(postID).delete()
                
                // 댓글 삭제
                let commentsQuerySnapshot = try await dbRef.document(postID).collection("Comments").getDocuments()
                
                for document in commentsQuerySnapshot.documents {
                    try await document.reference.delete()
                    
                    let replyCommentsQuerySnapshot = try await document.reference.collection("ReplyComments").getDocuments()
                    
                    for replyDocument in replyCommentsQuerySnapshot.documents {
                        try await replyDocument.reference.delete()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// - 댓글 작성 Action
    func writeComment(completion: @escaping () -> ()) {
        isLoading = true
        let comment = Comment(userName: userName,
                              userUID: userUID,
                              userImageURL: profileURL,
                              comment: commentText)
                
        Task {
            do {
                guard let postID = post.id else { return }
                
                let doc = dbRef.document(postID).collection("Comments").document()
                
                try doc.setData(from: comment)
                
                await MainActor.run {
                    var commentData = comment
                    commentData.id = doc.documentID
                    
                    commentText = ""
                    post.comments.append(commentData)
                    newComment = commentData
                    isLoading = false
                    completion()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// - 대댓글 작성 Action
    func writeReplyComment(completion: @escaping (String, Int, ReplyComment) -> ()) { // postID, commentIndex, [ReplyComment]
        isLoading = true
        let replyComment = ReplyComment(userName: userName,
                                        userUID: userUID,
                                        userImageURL: profileURL,
                                        comment: commentText)
        
        Task {
            do {
                guard let postID = post.id, let commentID = replyWritingCommentID, let commentIndex = replyWritingCommentIndex else { return }
                
                let doc = dbRef.document(postID).collection("Comments").document(commentID).collection("ReplyComments").document()
                
                try doc.setData(from: replyComment)
                
                await MainActor.run {
                    var replyCommentData = replyComment
                    replyCommentData.id = doc.documentID
                    
                    commentText = ""
                    post.comments[commentIndex].replyComments.append(replyCommentData)
                    newReplyComment = replyCommentData
                    self.commentPlaceholder = "댓글을 입력해보세요..."
                    
                    isLoading = false
                    completion(postID, commentIndex, replyCommentData)
                }
            }
        }
    }
    
    /// - 대댓글 작성 시작 Action
    func startWritingReplyComment(commentID: String, commentIndex: Int) {
        self.replyWritingCommentID = commentID
        self.replyWritingCommentIndex = commentIndex
        self.commentPlaceholder = "대댓글을 입력해보세요..."
    }
    
    /// - 게시물 스크랩 Action
    func postScrap() {
        
    }
}
