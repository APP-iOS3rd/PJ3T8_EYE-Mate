//
//  ButtonStyle.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct CustomBtn: View {
    let title: String
    let background: Color
    let fontStyle: Font
    let action: () -> Void
    
    var body: some View {
        Button{
            // Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(background)
                
                Text(title)
                    .foregroundStyle(.white)
                    .font(fontStyle)
            }
        }
        .padding()
    }
}

#Preview {
    CustomBtn(title: "Value", background: .customGreen, fontStyle: .pretendardMedium_18){
    }
}
