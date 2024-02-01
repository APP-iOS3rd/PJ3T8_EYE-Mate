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
    let userImageUrl: String
    let isDisplayLeftButton: Bool
    let leftButtonAction: () -> Void
    let profileButtonAction: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(title: String, 
         userImageUrl: String = "",
         isDisplayLeftButton: Bool = true,
         leftButtonAction: @escaping () -> Void = {},
         profileButtonAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.userImageUrl = userImageUrl
        self.isDisplayLeftButton = isDisplayLeftButton
        self.leftButtonAction = leftButtonAction
        self.profileButtonAction = profileButtonAction
    }
//    Image(systemName: "chevron.backward")
//        .resizable()
//        .frame(width: 16, height: 27)
//        .foregroundColor(.black)
//    
    var body: some View {
            HStack(alignment: .bottom) {
                if isDisplayLeftButton {
                    Button(action: { dismiss() },
                           label: {
                        Image(systemName: "chevron.backward")
                                .resizable()
                                .frame(width: 16, height: 32)
                                .foregroundColor(.black)
                    })
                }
                VStack(alignment: .leading) {
                    Text("EYE-Mate")
                        .font(.pretendardSemiBold_22)
                    Text(title)
                        .font(.pretendardBold_32)
                }
                .padding(.bottom, -3)
                Spacer()
                
                if userImageUrl != "" {
                    Button(action: profileButtonAction, label: {
                        KFImage(URL(string: userImageUrl))
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                } else {
                    Button(action: profileButtonAction, label: {
                        Image("defaultprofile")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                }
            }
            .padding(.horizontal, 20)
    }
}

#Preview {
    CustomNavigationTitle(title: "홈")
}
