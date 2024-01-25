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
                    .fill(Color.white.shadow(.drop(color: .gray, radius: 10, x: 2, y: 2)))
                    .stroke(Color.customGreen, lineWidth: 2)
                    .overlay(
                        HStack {
                            InfoView(coordinator: coordinator)
                            Spacer()
                            AsyncImageView(url: URL(string: coordinator.placeInfo[Key.image.rawValue] ?? ""))
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
