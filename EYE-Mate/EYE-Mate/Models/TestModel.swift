//
//  Record.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/06.
//

import Foundation
import FirebaseFirestore

//MARK: - 사용자 기록 모델
struct Visions: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    
    let left: String
    let right: String
    var publishedDate: Date = Date()
}

struct Colors: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    
    let status: String
    var publishedDate: Date = Date()
}

struct Astigmatisms: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    
    let left: String
    let right: String
    var publishedDate: Date = Date()
}

struct Sights: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    
    let left: String
    let right: String
    var publishedDate: Date = Date()
}
