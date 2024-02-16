//
//  SettingNavigationTabBar.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/05.
//

import SwiftUI

enum SettingNavigationBtnType: String {
    case close = "xmark"
    case back = "chevron.backward"
}

struct SettingNavigationTitle: View {
    let isDisplayTitle: Bool
    let leftBtnAction: () -> Void
    let leftBtnType: SettingNavigationBtnType
    let title: String
    
    init(
        isDisplayTitle: Bool = true,
        leftBtnAction: @escaping () -> Void = {},
        leftBtnType: SettingNavigationBtnType = .back,
        title: String = "닉네임 변경"
    ) {
        self.isDisplayTitle = isDisplayTitle
        self.leftBtnAction = leftBtnAction
        self.leftBtnType = leftBtnType
        self.title = title
    }
    
    
    var body: some View {
        HStack {
            Button(action: leftBtnAction) {
                Image(systemName: leftBtnType.rawValue)
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }
            
            Spacer()
            if isDisplayTitle {
                Text(title)
                    .font(.pretendardSemiBold_24)
            }
            Spacer()
        }
        .padding(20)
        .padding(.bottom, 20)
    }
}

#Preview {
    SettingNavigationTitle()
}
