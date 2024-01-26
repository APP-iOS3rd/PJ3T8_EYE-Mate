//
//  DistanceModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/25.
//

import Foundation

//MARK: - 테스트마다 조건을 확인하는 모델
class DistanceConditionViewModel: ObservableObject {
    @Published var distance: Int = 0
    
    init() {
        
    }
    
    var canStart: Bool {
        return distance >= 40 && distance <= 50
    }
    
    @MainActor
    func inputDistance(_ distance: Int) {
        print("\(distance)")
        self.distance = distance
    }
}
