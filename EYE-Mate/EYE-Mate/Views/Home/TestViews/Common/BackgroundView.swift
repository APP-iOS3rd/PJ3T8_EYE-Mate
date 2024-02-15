//
//  BackgroundView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/02.
//

import SwiftUI

//MARK: - Background 뷰
struct BackgroundView: View {
    var body: some View {
        GeometryReader { g in
            Rectangle()
                .ignoresSafeArea()
                .frame(width: g.size.width, height: g.size.height)
                .foregroundColor(.white)
        }
    }
}
#Preview {
    BackgroundView()
}
