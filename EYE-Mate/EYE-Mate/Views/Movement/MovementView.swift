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
        VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading, spacing: 12){
                                Text("EYE-Mate")
                                    .font(.pretendardSemiBold_22)
                                Text("눈 운동")
                                    .font(.pretendardSemiBold_32)
                            }
                            Spacer()
                            Circle()
                                .foregroundColor(Color.blue)
                                .frame(width: 50, height: 50)
                        }
                            .frame(height: 112)
                            .padding(.horizontal, 24)

                        HorizontalDivider(color: Color.customGreen, height: 4)
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading) {
                                Text("어디로 가야 하오 님!")
                                    .font(.pretendardSemiBold_22)
                                Text("오늘도 눈 건강 챙기셨나요? 👀")
                                    .font(.pretendardRegular_22)
                            }
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            VStack(alignment: .leading) {
                                Text("#오늘의 눈 운동")
                                    .font(.pretendardRegular_16)
                                Text("0회")
                                    .font(.pretendardSemiBold_20)
                            }
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            Spacer()
                        }
                        .frame(width: .infinity)
                        .padding(.horizontal, 32)
                        .padding(.top, 16)
                        .background(Color.textFieldGray)
                    }
    }
}

#Preview {
    MovementView()
}
