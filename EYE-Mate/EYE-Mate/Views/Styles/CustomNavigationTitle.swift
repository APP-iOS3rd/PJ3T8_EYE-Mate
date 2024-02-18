//
//  CustomNavigationTitle.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI
import Kingfisher

struct CustomNavigationTitle: View {
    let title: String
    let isDisplayLeftButton: Bool
    let leftButtonAction: () -> Void
    let profileButtonAction: () -> Void
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    
    init(title: String = "",
         isDisplayLeftButton: Bool = true,
         leftButtonAction: @escaping () -> Void = {},
         profileButtonAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.isDisplayLeftButton = isDisplayLeftButton
        self.leftButtonAction = leftButtonAction
        self.profileButtonAction = profileButtonAction
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if isDisplayLeftButton {
                Button(action: { dismiss() },
                       label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 32))
                        .foregroundColor(.black)
                })
            }
            VStack(alignment: .leading) {
                Text("EYE-Mate")
                    .font(.pretendardSemiBold_22)
                    .padding(.leading, 6)
                Spacer()
                    .frame(height: 10)
                
                Text(title)
                    .font(.pretendardBold_32)
            }
            .padding(.bottom, title == "" ? 21 : -3)
            Spacer()
            
            Button(action: profileButtonAction, label: {
                profileViewModel.profileImage
                    .ProfileImageModifier()
                    .frame(width: 50, height: 50)
            })
        }
        .padding(20)
    }
}

#Preview {
    CustomNavigationTitle(title: "홈")
}
