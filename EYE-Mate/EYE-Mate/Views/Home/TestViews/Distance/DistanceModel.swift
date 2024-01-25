//
//  DistanceModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/25.
//

import Foundation

class DistanceModel: ObservableObject {
    @Published var distance: Int = 0
    
    init() {
        
    }
    
    func inputDistance(_ distance: Int) {
        self.distance = distance
    }
}
