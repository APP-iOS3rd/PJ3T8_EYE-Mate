//
//  HorizontalDivider.swift
//  EYE-Mate
//
//  Created by seongjun on 1/26/24.
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

#Preview {
    HorizontalDivider(color: Color.customGreen, height: 4)
}
