//
//  tempUser.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/06.
//

import Foundation
import FirebaseFirestore

struct tempUser: Identifiable, Codable {
    @DocumentID var id: String?
    var userName: String
    var userUID: String
    var userImageURL: String?
    
}
