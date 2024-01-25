//
//  ActionAreaView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI

struct ActionAreaView: View {
    @ObservedObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            AsyncImageView(url: URL(string: coordinator.placeInfo[Key.image.rawValue] ?? ""))
            
            Button(action: {
                // Your action code for 길찾기 goes here
            }) {
                Label("길찾기", systemImage: "location")
            }
            .buttonStyle(MapButtonStyle())
        }
    }
}

