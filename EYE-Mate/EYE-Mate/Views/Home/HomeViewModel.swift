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
    
    init(user: UserModel = UserModel(name: "어디로 가야하오", movement: 3, leftEyeSight: "0.5", rightEyeSight: "0.8")
    ) {
        self.user = user
    }
    
}
