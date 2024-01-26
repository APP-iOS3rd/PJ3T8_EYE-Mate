//
//  MapModalView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/24.
//

import SwiftUI

struct MapModalView: View {
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color.customGreen, lineWidth: 3)
            .cornerRadius(20)
            .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 5, x: 2, y: 2)
                )
            .overlay(
                HStack {
                    InfoView(coordinator: coordinator)
                    Spacer()
                    ActionAreaView(coordinator: coordinator)
                }
                .padding(15)
            )
            .frame(maxWidth: .infinity, maxHeight: 160)
            .padding(.horizontal, 20)
    }
}


#Preview {
    MapModalView()
}
