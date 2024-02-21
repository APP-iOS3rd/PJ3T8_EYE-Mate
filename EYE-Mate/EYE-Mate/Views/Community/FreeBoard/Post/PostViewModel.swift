//
//  PostViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/6/24.
//

import SwiftUI

import FirebaseFirestore
import FirebaseStorage
import Kingfisher

class PostViewModel: ObservableObject {
    @Published var post: Post
    
    @Published var isLoading: Bool = false
    
    // ExpandImageView
    @Published var showImageViewer = false
    @Published var imageViewerOffset: CGSize = .zero
    @Published var selectedImages: [KFImage] = []
    @Published var selectedImageIndex: Int = -1
    @Published var bgOpacity: Double = 1
    @Published var imageScale: CGFloat = 1
    
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
    
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    
    private let dbRef = Firestore.firestore().collection("Posts")
    
    init(post: Post) {
        self.post = post
        
        if let postImageURLs = post.postImageURLs{
            for url in postImageURLs {
                selectedImages.append(KFImage(url))
            }
        }
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
                // 배열에 사용자 ID 추가
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
                              userImageURL: userProfileURL,
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
                                        userImageURL: userProfileURL,
                                        comment: commentText)
        
        Task {
            do {
                guard let postID = post.id, let commentID = replyWritingCommentID, let commentIndex = replyWritingCommentIndex else { return }
                
                let doc = dbRef.document(postID)
                    .collection("Comments")
                    .document(commentID)
                    .collection("ReplyComments")
                    .document()
                
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
        Task {
            guard let postID = post.id else { return }
            
            let dbRef = Firestore.firestore().collection("Posts").document(postID)
            
            if post.scrapIDs.contains(userUID) {
                // 배열에서 사용자 ID 제거
                try await dbRef.updateData([
                    "scrapIDs" : FieldValue.arrayRemove([userUID])
                ])
            } else {
                // 배열에 사용자 ID 추가
                try await dbRef.updateData([
                    "scrapIDs" : FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    // ExpandImageView 드래그에 따른 높이와 배경 Opacity 조절
    func onChangeImageViewer(value: CGSize) {
        DispatchQueue.main.async {
            self.imageViewerOffset = value
            
            guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let screenHeight = window.screen.bounds.height
            
            let halgHeight = screenHeight / 2
            
            let progress = self.imageViewerOffset.height / halgHeight
            
            withAnimation(.default) {
                self.bgOpacity = Double(1 - progress)
            }
        }
    }
    
    // ExpandImageView 드래그 정도에 따라 화면 toggle
    func onEnd(value: DragGesture.Value) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut) {
                var translation = value.translation.height
                
                if translation < 0 {
                    translation = -translation
                }
                
                if translation < 250 {
                    self.imageViewerOffset = .zero
                    self.bgOpacity = 1
                } else {
                    self.showImageViewer.toggle()
                    self.imageViewerOffset = .zero
                    self.bgOpacity = 1
                    self.imageScale = 1
                }
            }
        }
    }
}
