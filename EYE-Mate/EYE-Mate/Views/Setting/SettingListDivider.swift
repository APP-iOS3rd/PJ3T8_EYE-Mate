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
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.tabGray)
            .padding(.horizontal, 20)
    }
}

#Preview {
    SettingListDivider()
}
