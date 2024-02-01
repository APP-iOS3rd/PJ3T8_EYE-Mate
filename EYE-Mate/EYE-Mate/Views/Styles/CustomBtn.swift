//
//  ButtonStyle.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct CustomBtn: View {
    let title: String
    let isLabel: Bool
    let background: Color
    let fontStyle: Font
    let action: () -> Void
    
    init(title: String = "",
         isLabel: Bool = false,
         background: Color,
         fontStyle: Font,
         action: @escaping () -> Void) {
        self.title = title
        self.isLabel = isLabel
        self.background = background
        self.fontStyle = fontStyle
        self.action = action
    }
    
    var body: some View {
        Button{
            // Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                if !isLabel {
                    Text(title)
                        .foregroundStyle(.white)
                        .font(fontStyle)
                } else {
                    Label(
                        title: { Text("내 주변 병원보기") },
                        icon: { Image(systemName: "map.fill") }
                    )
                    .foregroundColor(.white)
                }
            }
        }
        .padding()
    }
}

#Preview {
    CustomBtn(title: "Value", background: .customGreen, fontStyle: .pretendardMedium_18){
    }
}
