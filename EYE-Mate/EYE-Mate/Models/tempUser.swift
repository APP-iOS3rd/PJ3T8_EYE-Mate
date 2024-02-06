//
//  tempUser.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/06.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var userUID: String
    var userImageURL: URL
    
}
