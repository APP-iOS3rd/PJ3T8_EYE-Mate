//
//  FreeBoardViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 1/30/24.
//

import SwiftUI
import Foundation
import FirebaseFirestore

class FreeBoardViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isFetching: Bool = true
    
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    // MARK: Posts Fetch Function
    func fetchPosts() async {
        do {
            var query: Query!
            
            // MARK:  Pagination
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
            let fetchedPosts = docs.documents.compactMap{ doc -> Post? in
                try? doc.data(as: Post.self)
            }
            
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
