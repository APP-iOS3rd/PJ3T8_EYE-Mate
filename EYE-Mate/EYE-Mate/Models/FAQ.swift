//
//  FAQ.swift
//  EYE-Mate
//
//  Created by Taejun Ha on 2/18/24.
//

import SwiftUI

import FirebaseFirestore

struct FAQ: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    
    var question: String
    var answer: String
}
