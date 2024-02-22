//
//  HomeViewModel.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/30.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    static let shared = HomeViewModel()
    @Published var isPresentedRecordView = false
    
    @Published var isPresentedVisionView = false
    @Published var isPresentedColorView = false
    @Published var isPresentedAstigmatismView = false
    @Published var isPresentedSightView = false
}

//MARK: - Firebase Methods
extension HomeViewModel {
    
}
