//
//  DistanceModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/25.
//

import Foundation
import SwiftUI

//MARK: - 테스트마다 조건을 확인하는 모델
class DistanceConditionViewModel: ObservableObject {
    @Published var distance: Int = 0
    
    @Published var isActiveVisionTest = false
    @Published var isActiveAstigmatismTest = false
    @Published var isActiveSightTest = false
    
    var canStart: Bool {
        return distance >= 40 && distance <= 50
    }
    
    var informationText: String {
        canStart ? "테스트가 가능합니다." : "테스트 가능한 거리가 되면\n버튼이 활성화됩니다."
    }
    
    var canSightStart: Bool {
        return distance >= 30 && distance <= 40
    }
    
    var sightInformationText: String {
        canSightStart ? "테스트가 가능합니다." : "테스트 가능한 거리가 되면\n버튼이 활성화됩니다."
    }
    
    @MainActor
    func inputDistance(_ distance: Int) {
        print("\(distance)")
        self.distance = distance
    }
}
