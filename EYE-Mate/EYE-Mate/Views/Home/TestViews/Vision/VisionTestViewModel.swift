//
//  VisionTestViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/15.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class VisionTestViewModel: ObservableObject {
    static let shared = VisionTestViewModel()
    
    @Published var answerArray : [String] = ["C", "2", "3", "4", "5", "6", "7", "비", "미", "므", "무", "기", "브", "누"]
    // 정답
    @Published var answer: String = ""
    // 유저가 제출한 정답
    @Published var userAnswer: String = ""
    
    @Published var opportunity = 4
    
    // 질문할 문제 리스트
    @Published var question: [String] = []
    // 결과창에서 보여줄 측정거리 값
    @Published var userDistance = 0
    
    private let visionArray = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.5, 2.0]
//    private let fontArray = [0.795, 0.525, 0.33, 0.27, 0.195, 0.165, 0.15, 0.135, 0.12, 0.105, 0.09, 0.0825, 0.0675, 0.045]
    private var index = 6
    
    // 글자 크기
    @Published var fontSize = 21
    @Published var leftVision = "1.2"
    @Published var rightVision = "0.3"
    // 다음 버튼 활성화
    @Published var nextButton = false
    
    @Published var showFullScreenCover: Bool = false
    
    
    func saveDistance(_ distance: Int) {
        userDistance = distance
    }
    
    func change() {
        answerArray += question
        question.removeAll()
        
        var randomIndex = Int.random(in: 0..<answerArray.count)
        answer = answerArray[randomIndex]
        answerArray.remove(at: randomIndex)
        question.append(answer)
        
        for _ in 0..<2 {
            randomIndex = Int.random(in: 0..<answerArray.count)
            question.append(answerArray[randomIndex])
            answerArray.remove(at: randomIndex)
        }
        
        question.shuffle()
    }
    
    func checkAnswer(_ value: Binding<Bool>, _ type: BothEyes) {
        if answer == userAnswer {
            correctAnswer(value, type)
        } else {
            wrongAnswer(value, type, userAnswer == "?")
        }
    }
    
    func correctAnswer(_ value: Binding<Bool>, _ type: BothEyes) {
        //TODO: - 눈 방향에 맞춰 글자크기 줄이기
        fontSize -= 3
        index += 1
        if index >= 13 {
            fontSize = 21
            switch type {
            case .left:
                leftVision = "\(visionArray[index - 1])"
            case .right:
                rightVision = "\(visionArray[index - 1])"
            }
            index = 6
            value.wrappedValue.toggle()
        }
        change()
    }
    
    func wrongAnswer(_ value: Binding<Bool>, _ type: BothEyes, _ confused: Bool){
        opportunity -= 1
        if opportunity == 0 {
            // 다른 눈을 위해 기회 초기화
            opportunity = 4
            switch type {
            case .left:
                leftVision = "\(visionArray[index])"
            case .right:
                rightVision = "\(visionArray[index])"
            }
            index = 6
            fontSize = 21
            value.wrappedValue.toggle()
        } else {
            if confused {
                fontSize += 6
                index -= 2
                if index <= 0 {
                    fontSize = 42
                    index = 0
                }
            } else {
                //TODO: - 눈 방향에 맞춰 글자크기 키우기
                fontSize += 3
                index -= 1
                if index <= 0 {
                    fontSize = 42
                    index = 0
                }
            }
            change()
        }
    }
    
    func fontColor(_ eye: String) -> Color {
        let eye = Double(eye)!
        if eye >= 1.2 {
            return .customGreen
        } else if eye >= 0.7 {
            return .lightYellow
        } else {
            return .lightRed
        }
    }
    
    var explainText: String {
        let left = Double(leftVision)!
        let right = Double(rightVision)!
        if left >= 1.2 && right >= 1.2 {
            return "평균보다 높게 나왔어요!\n눈 건강 유지를 위해 주기적인 눈검사를 권장드려요."
        } else if left >= 0.7 && right >= 0.7 {
            return "시력이 평균을 유지하고 있어요!\n눈 건강 유지를 위해 주기적인 눈검사를 권장드려요."
        } else {
            return "평균보다 낮게 나왔어요!\n정확한 진단을 위해 병원 방문을 추천드려요."
        }
    }
}

enum BothEyes {
    case left, right
}

//MARK: - Firebase Method
extension VisionTestViewModel {
    func saveResult(_ uid: String) {
        let visionDoc = Firestore.firestore()
            .collection("Records")
            .document(uid)
            .collection("Visions")
            .document()
        
        let visionItem = Visions(left: leftVision,
                                 right: rightVision)
        
        do {
            let _ = try visionDoc.setData(from: visionItem)
        } catch {
            print("error: \(error.localizedDescription)")
        }
        
    }
}



