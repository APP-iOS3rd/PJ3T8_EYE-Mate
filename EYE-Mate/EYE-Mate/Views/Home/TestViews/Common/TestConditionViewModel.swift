//
//  DistanceModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/25.
//

import Foundation

//MARK: - 테스트마다 조건을 확인하는 모델
class TestConditionViewModel: ObservableObject {
    @Published var distance: Int = 0
    
    init() {
        
    }
    
    @MainActor
    func inputDistance(_ distance: Int) {
        print("\(distance)")
        self.distance = distance
    }
}
