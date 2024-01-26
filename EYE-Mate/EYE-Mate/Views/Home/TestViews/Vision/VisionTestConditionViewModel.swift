//
//  VisionTestConditionViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/26.
//

import Foundation

class VisionTestConditionViewModel: TestConditionViewModel {
    
    var canStart: Bool {
        return distance >= 40 && distance <= 50
    }
    
    override init() {
        
    }
}
