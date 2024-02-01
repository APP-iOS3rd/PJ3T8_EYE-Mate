//
//  ColorTestViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import Foundation
import SwiftUI

class ColorTestViewModel: ObservableObject {
    let testColorSet = [Image("Ishihara_12"),
                        Image("Ishihara_74"),
                        Image("Ishihara_6"),
                        Image("Ishihara_16"),
                        Image("Ishihara_2"),
                        Image("Ishihara_29"),
                        Image("Ishihara_7"),
                        Image("Ishihara_45"),
                        Image("Ishihara_5"),
                        Image("Ishihara_97"),
                        Image("Ishihara_8"),
                        Image("Ishihara_42"),
                        Image("Ishihara_3"),
    ]
    
    let answerSet = ["12", "74", "6", "16", "2", "29", "7", "45", "5", "97", "8", "42", "3"]
    
    @Published var userAnswer: [String] = []
    @Published var index: Int = 0
    @Published var isTestStarted: Bool = false
    private var count: Int = 0
    
    func updateResult() {
        var tmp = 0
        for i in 1..<testColorSet.count {
            if userAnswer[i] == answerSet[i] {
                tmp += 1
            }
        }
        count = tmp
    }
    
    var result: String {
        return "\(Int(Double(count) / 12.0 * 100))% 정답률(\(count) / \(testColorSet.count - 1))"
    }
    
    var resultMessage: String {
        if count >= testColorSet.count - 2 {
            return "정상적인 색채 지각"
        } else if count >= testColorSet.count - 5 {
            return "경미한 색채 지각 이상"
        } else if count >= testColorSet.count - 8 {
            return "중증도의 색채 지각 이상"
        } else {
            return "심각한 색채 지각 이상"
        }
    }
}
