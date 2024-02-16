//
//  ImageExtension.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/10.
//

import SwiftUI

extension Image {
    func ProfileImageModifier() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
    }
}
