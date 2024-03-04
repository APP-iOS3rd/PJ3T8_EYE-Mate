//
//  MovementViewModel.swift
//  EYE-Mate
//
//  Created by seongjun on 2/22/24.
//

import SwiftUI

class MovementViewModel: ObservableObject {
    static let shared = MovementViewModel()
    
    @Published var showToast = false
}
