//
//  Movement.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

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
                        Spacer()
                    }
    }
}

#Preview {
    MovementView()
}
