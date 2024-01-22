//
//  EYE_MateApp.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI
import FirebaseCore

@main
struct EYE_MateApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            Main()
        }
    }
}
