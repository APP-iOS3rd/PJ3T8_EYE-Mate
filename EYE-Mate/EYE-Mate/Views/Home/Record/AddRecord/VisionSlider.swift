//
//  VisionSlider.swift
//  EYE-Mate
//
//  Created by seongjun on 2/7/24.
//

import SwiftUI

struct VisionSlider: View {
    @Binding var value: Float

    let label: String

    var body: some View {
        HStack(spacing: 16) {
            Text("\(label)").font(.pretendardRegular_14)
            VStack(spacing: 6) {
                CustomSlider(
                    thumbColor: .white,
                    minTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 1),
                    maxTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 0.2),
                    value: $value
                )
                Text("\(String(format: "%.1f", value))").font(.pretendardRegular_12)
            }.padding(.top, 18)
        }
        .padding(.leading, 12)
        .padding(.trailing, 12)
    }
}

#Preview {
    VisionSlider(value: .constant(1.0), label: "좌")
}
