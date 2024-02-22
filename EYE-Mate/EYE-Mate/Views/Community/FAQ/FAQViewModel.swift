//
//  FAQViewModel.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/22/24.
//

import SwiftUI

import FirebaseFirestore

class FAQViewModel: ObservableObject {
    @Published var FAQs: [FAQ] = []
    @Published var isFetching: Bool = true
    
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    @Published var paginationDoc: QueryDocumentSnapshot?
    
    /// - FAQ Fetch
    func fetchFAQ() async {
        do {
            var query: Query!
            
            // MARK: FAQ Pagination
            if let paginationDoc {
                query = Firestore.firestore().collection("FAQ")
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("FAQ")
                    .limit(to: 20)
            }
            
            let docs = try await query.getDocuments()
            let fetchedFAQs = docs.documents.compactMap{ try? $0.data(as: FAQ.self) }
            
            await MainActor.run {
                FAQs.append(contentsOf: fetchedFAQs)
                
                paginationDoc = docs.documents.last
                isFetching = false
            }
        } catch {
            print("FAQViewModel - fetchFAQ() error: \(error.localizedDescription)")
        }
    }
    
    /// - 검색어를 포함한 FAQ Fetch
    func fetchFAQ(searchText: String) async {
        do {
            var query: Query!
            query = Firestore.firestore().collection("FAQ")
            
            let docs = try await query.getDocuments()
            let fetchedFAQs = docs.documents.compactMap{
                let faq = try? $0.data(as: FAQ.self)
                
                if let faq = faq, faq.question.contains(searchText) || faq.answer.contains(searchText) {
                    return faq
                } else {
                    return nil
                }
            }
            
            await MainActor.run {
                FAQs = fetchedFAQs
                isFetching = false
            }
        } catch {
            print("FAQViewModel - fetchFAQ(searchText: String) error: \(error.localizedDescription)")
        }
    }
}
