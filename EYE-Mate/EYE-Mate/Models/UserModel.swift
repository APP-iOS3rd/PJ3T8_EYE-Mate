//
//  UserModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import Foundation

struct UserModel: Hashable {
    var name: String
    var movement: Int
    var leftEyeSight: String
    var rightEyeSight: String
    
    init(name: String, movement: Int, leftEyeSight: String, rightEyeSight: String) {
        self.name = name
        self.movement = movement
        self.leftEyeSight = leftEyeSight
        self.rightEyeSight = rightEyeSight
    }
}
