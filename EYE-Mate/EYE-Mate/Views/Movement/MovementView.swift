//
//  Movement.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct HorizontalDivider: View {
    let color: Color
    let height: CGFloat
    
    init(color: Color, height: CGFloat = 0.5) {
        self.color = color
        self.height = height
    }
    
    var body: some View {
        color
            .frame(height: height)
    }
}

struct MovementView: View {
    var body: some View {
                    VStack {
                        HStack{
                            VStack(alignment: .leading, spacing: 12){
                                Text("EYE-Mate")
                                    .font(.pretendardSemiBold_22)
                                Text("눈 운동")
                                    .font(.pretendardBold_32)
                            }
                            Spacer()
                            Circle()
                                .foregroundColor(Color.blue)
                                .frame(width: 50, height: 50)
                        }
                            .frame(height: 112)
                            .padding(.horizontal, 24)
                        HorizontalDivider(color: Color.customGreen, height: 4)
                        Spacer()
                    }
    }
}

#Preview {
    MovementView()
}
