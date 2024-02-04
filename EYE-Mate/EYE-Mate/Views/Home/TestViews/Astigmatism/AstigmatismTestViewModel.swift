//
//  AstigmatismTestViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/02.
//

import Foundation

class AstigmatismTestViewModel: ObservableObject {
    @Published var userAnswer: [String] = []
    @Published var userSayYes = false
    @Published var userSayNo = false
    
    var isLeftEye: Bool {
        userAnswer[0] == "Y" ? true : false
    }
    
    var isRightEye: Bool {
        userAnswer[1] == "Y" ? true : false
    }
    
    var leftImage: String {
        isLeftEye ? "Component9" : "Component10"
    }
    
    var rightImage: String {
        isRightEye ? "Component9" : "Component10"
    }
    
    var titleText: String {
        if isLeftEye && isRightEye {
            return "난시 증상"
        } else if !isLeftEye && isRightEye {
            return "왼쪽 눈"
        } else if isLeftEye && !isRightEye {
            return "오른쪽 눈"
        } else {
            return "양쪽 눈"
        }
    }
    
    var subTitleText: String {
        if isLeftEye && isRightEye {
            return "을 보이는 것 같지 않습니다."
        } else {
            return "에서 난시 증상이 발견되었습니다."
        }
    }
    
    var explainText: String {
        if isLeftEye && isRightEye {
            return "눈건강 유지를 위해\n주기적으로 정밀 눈 검사를 권장드려요."
        } else {
            return "정확한 진단을 위해\n정밀 눈 검사를 받아보는걸 추천드려요."
        }
    }
}
