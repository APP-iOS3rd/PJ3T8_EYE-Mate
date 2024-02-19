//
//  CommentViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/13/24.
//

import SwiftUI

import FirebaseFirestore

class CommentViewModel: ObservableObject {
    @Published var comments: [Comment]
    
    private var selectedPostID: String?
    
    @Binding var isLoading: Bool
    
    @AppStorage("user_UID") var userUID: String = ""
        
    init(comments: [Comment], selectedPostID: String? = nil, isLoading: Binding<Bool>) {
        self.comments = comments
        self.selectedPostID = selectedPostID
        self._isLoading = isLoading
    }
    
    func append(newComment: Comment) {
        comments.append(newComment)
    }
    
    func append(at: Int, newReplyComment: ReplyComment) {
        comments[at].replyComments.append(newReplyComment)
    }
    
    /// - 대댓글 작성 Action
    func startWritingReplyComment(commentID: String?, startWritingReplySignal: @escaping (String, Int) -> ()) {
        guard let commentID = commentID else { return }
        
        if let commentIndex = comments.firstIndex(where: { comment in comment.id == commentID}) {
            startWritingReplySignal(commentID, commentIndex)
        }
    }
    
    /// - 댓글 좋아요 Action
    func likeComment(commentID: String?, updateLocalData: @escaping (String, Int) -> ()) {
        Task {
            guard let postID = selectedPostID, let commentID = commentID else { return }
            
            let dbRef = Firestore.firestore()
                .collection("Posts")
                .document(postID)
                .collection("Comments")
                .document(commentID)
            
            if let index = comments.firstIndex(where: { comment in comment.id == commentID }) {
                do {
                    if comments[index].likedIDs.contains(userUID) {
                        // 사용자 ID 제거
                        try await dbRef.updateData([
                            "likedIDs" : FieldValue.arrayRemove([userUID])
                        ])
                        
                        await MainActor.run {
                            comments[index].likedIDs.removeAll { $0 == userUID }
                            updateLocalData(postID, index)
                        }
                    } else {
                        // 사용자 ID 추가
                        try await dbRef.updateData([
                            "likedIDs" : FieldValue.arrayUnion([userUID])
                        ])
                        
                        await MainActor.run {
                            comments[index].likedIDs.append(userUID)
                            updateLocalData(postID, index)
                        }
                    }
                } catch {
                    print("[CommentViewModel] - likeComment() : \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// - 대댓글 좋아요 Action
    func likeReplyComment(commentID: String?, replyCommentID: String?, updateLocalData: @escaping (String, Int, Int) -> ()) {
        Task {
            guard let postID = selectedPostID, let commentID = commentID, let replyCommentID = replyCommentID else { return }
            
            let dbRef = Firestore.firestore()
                .collection("Posts")
                .document(postID)
                .collection("Comments")
                .document(commentID)
                .collection("ReplyComments")
                .document(replyCommentID)
            
            if let commentIndex = comments.firstIndex(where: { comment in
                comment.id == commentID
            }), let replyCommentIndex = comments[commentIndex].replyComments.firstIndex(where: { replyComment in
                replyComment.id == replyCommentID
            }) {
                do {
                    if comments[commentIndex].replyComments[replyCommentIndex].likedIDs.contains(userUID) {
                        /// Firestore 업데이트
                        try await dbRef.updateData([
                            "likedIDs" : FieldValue.arrayRemove([userUID])
                        ])
                        
                        /// Local Data 업데이트
                        await MainActor.run {
                            comments[commentIndex].replyComments[replyCommentIndex].likedIDs.removeAll { $0 == userUID }
                            updateLocalData(postID, commentIndex, replyCommentIndex)
                        }
                    } else {
                        /// Firestore 업데이트
                        try await dbRef.updateData([
                                "likedIDs" : FieldValue.arrayUnion([userUID])
                            ])
                        
                        /// Local Data 업데이트
                        await MainActor.run {
                            comments[commentIndex].replyComments[replyCommentIndex].likedIDs.append(userUID)
                            updateLocalData(postID, commentIndex, replyCommentIndex)
                        }
                    }
                } catch {
                    print("[CommentViewModel] - likeReplyComment() : \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// - 댓글 삭제 ( 해당 댓글의 대댓글도 함께 삭제되어야함 )
    func deleteComment(commentID: String?, updateLocalData: @escaping (String, Int) -> ()) {
        isLoading = true
        
        Task {
            guard let postID = selectedPostID, let commentID = commentID else { return }
            
            let dbRef = Firestore.firestore()
                .collection("Posts")
                .document(postID)
                .collection("Comments")
                .document(commentID)
            
            if let commentIndex = comments.firstIndex(where: { $0.id == commentID }) {
                do {
                    try await dbRef.delete()
                    
                    let replyCommentsQuerySnapshot = try await dbRef.collection("ReplyComments").getDocuments()
                    
                    for document in replyCommentsQuerySnapshot.documents {
                        try await document.reference.delete()
                    }
                    
                    await MainActor.run {
                        comments.remove(at: commentIndex)
                        isLoading = false
                        updateLocalData(postID, commentIndex)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteReplyComment(commentID: String?, replyCommentID: String?, updateLocalData: @escaping (String, Int, Int) -> ()) { // postID, commentIndex,replyCommentIndex
        isLoading = true
        
        Task {
            guard let postID = selectedPostID, let commentID = commentID, let replyCommentID = replyCommentID else { return }
            
            let dbRef = Firestore.firestore()
                .collection("Posts")
                .document(postID)
                .collection("Comments")
                .document(commentID)
                .collection("ReplyComments")
                .document(replyCommentID)
            
            if let commentIndex = comments.firstIndex(where: { $0.id == commentID }),
               let replyCommentIndex = comments[commentIndex].replyComments.firstIndex(where: { $0.id == replyCommentID }){
                do {
                    try await dbRef.delete()
                    
                    await MainActor.run {
                        comments[commentIndex].replyComments.remove(at: replyCommentIndex)
                        isLoading = false
                        updateLocalData(postID, commentIndex, replyCommentIndex)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
