//
//  SettingListDivider.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/02.
//

import SwiftUI

struct SettingListDivider: View {
    
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width - 80, height: 1)
            .foregroundStyle(Color.tabGray)
    }
}

#Preview {
    SettingListDivider()
}
