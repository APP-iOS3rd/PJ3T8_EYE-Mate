//
//  SettingTitleModifier.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import SwiftUI

struct SettingTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundStyle(Color.tabGray)
                    .opacity(0.2)
                    .frame(width: UIScreen.main.bounds.width - 70, height: 45)
            }
            .frame(width: UIScreen.main.bounds.width - 70, height: 45)
    }
}

#Preview {
    SettingTitleModifier() as! any View
}
