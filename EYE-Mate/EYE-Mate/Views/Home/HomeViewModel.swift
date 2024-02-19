//
//  HomeViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/30.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isPresentedRecordView = false
    
    @Published var isPresentedVisionView = false
    @Published var isPresentedColorView = false
    @Published var isPresentedAstigmatismView = false
    @Published var isPresentedSightView = false
    
    @Published var user: UserModel
    @Published var onboardingModel: EyeSenseOnBoardingViewModel
    
    init(user: UserModel = UserModel(name: "어디로 가야하오", movement: 3, leftEyeSight: "0.5", rightEyeSight: "0.8"),
         onboardingModel: EyeSenseOnBoardingViewModel = EyeSenseOnBoardingViewModel(title: "오늘의 눈 상식", subTitle: "전자기기를 보면 눈이 안좋아져요!")
    ) {
        self.user = user
        self.onboardingModel = onboardingModel
    }
    
}
