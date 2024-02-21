//
//  User.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/2/24.
//

import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var userName: String
    var userUID: String
    var userImageURL: String?
    
    var left: String
    var right: String
}
