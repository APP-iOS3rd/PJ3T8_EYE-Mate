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
    let userImgUrl: String
    let isDisplayLeftBtn: Bool
    let leftBtnAction: () -> Void
    let profileBtnAction: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    init(title: String, 
         userImgUrl: String = "",
         isDisplayBtn: Bool = true,
         leftBtnAction: @escaping () -> Void = {},
         profileBtnAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.userImgUrl = userImgUrl
        self.isDisplayLeftBtn = isDisplayBtn
        self.leftBtnAction = leftBtnAction
        self.profileBtnAction = profileBtnAction
    }
    
    var body: some View {
            HStack(alignment: .lastTextBaseline) {
                if isDisplayLeftBtn {
                    Button(action: { dismiss() }, 
                           label: {
                        Image("leftArrow")
                    })
                }
                VStack(alignment: .leading) {
                    Text("EYE-Mate")
                        .font(.pretendardSemiBold_22)
                    Text(title)
                        .font(.pretendardBold_32)
                }
                
                Spacer()
                
                if userImgUrl != "" {
                    Button(action: profileBtnAction, label: {
                        KFImage(URL(string: userImgUrl))
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                } else {
                    Button(action: profileBtnAction, label: {
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
