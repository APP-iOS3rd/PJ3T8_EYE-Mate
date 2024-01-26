//
//  mapButtonStyle.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI

struct MapButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.pretendardSemiBold_12)
            .foregroundStyle(configuration.isPressed ? Color.customGreen : Color.white)
            .frame(width: 90, height: 30)
            .background(configuration.isPressed ? .white : .customGreen)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 1)
                )
            
    }
}
