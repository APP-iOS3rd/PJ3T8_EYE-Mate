//
//  MapImgModifier.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI

struct MapImgModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 90, height: 90)
            .clipped()
            .cornerRadius(10)
    }
}
