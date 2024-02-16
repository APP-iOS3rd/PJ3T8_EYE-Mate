//
//  FreeBoardViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/30/24.
//

import SwiftUI

import FirebaseFirestore

class FreeBoardViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isFetching: Bool = true
    
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    // MARK: Posts Fetch Function
    func fetchPosts() async {
        do {
            var query: Query!
            
            // MARK: 게시물 Pagination
            if let paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = try await docs.documents.asyncMap{ doc -> Post? in
                var post = try? doc.data(as: Post.self)
                
                // Comment 가져오기
                guard let postID = post?.id else { return nil }
                let commentsQuerySnapshot = try await Firestore.firestore()
                    .collection("Posts")
                    .document(postID)
                    .collection("Comments")
                    .order(by: "publishedDate", descending: false)
                    .getDocuments()
                
                post?.comments = try await commentsQuerySnapshot.documents.asyncMap{ commentDoc -> Comment? in
                    var comment = try? commentDoc.data(as: Comment.self)
                    
                    // 댓글의 대댓글 가져오기
                    let replyCommentsQuerySnapshot = try await Firestore.firestore()
                        .collection("Posts")
                        .document(postID)
                        .collection("Comments")
                        .document(commentDoc.documentID)
                        .collection("ReplyComments")
                        .order(by: "publishedDate", descending: false)
                        .getDocuments()
                    
                    comment?.replyComments = replyCommentsQuerySnapshot.documents.compactMap{ replyDoc -> ReplyComment? in
                        try? replyDoc.data(as: ReplyComment.self)
                    }
                    
                    return comment
                }.compactMap{ $0 }
                
                return post
            }.compactMap{ $0 }
            
            await MainActor.run {
                posts.append(contentsOf: fetchedPosts)
                
                // Pagination에 사용하기 위해 마지막에 가져온 Document를 저장
                paginationDoc = docs.documents.last
                isFetching = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func refreshable() async {
        await MainActor.run {
            isFetching = true
            posts = []
        }
        
        paginationDoc = nil
        await fetchPosts()
    }
}

// 비동기 Map
extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}
