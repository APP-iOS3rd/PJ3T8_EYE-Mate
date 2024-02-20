//
//  User.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/2/24.
//

import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userUID: String
    var userImageURL: URL
    
    var left: String?
    var right: String?
    
    var todayMovementCount: Int = 0    
}
