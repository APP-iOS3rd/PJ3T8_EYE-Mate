//
//  CustomNavigationTitle.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct CustomNavigationTitle: View {
    let title: String
    let userImg: Image
    let isDisplayLeftBtn: Bool
    let leftBtnAction: () -> Void
    let profileBtnAction: () -> Void
    @State private var loggedIn = UserDefaults.standard.bool(forKey: "Login")
    @Environment(\.dismiss) private var dismiss
    
    init(title: String, 
         userImg: Image = Image(systemName: "person.fill"),
         isDisplayBtn: Bool = true,
         leftBtnAction: @escaping () -> Void = {},
         profileBtnAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.userImg = userImg
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
                
                if loggedIn {
                    Button(action: profileBtnAction, label: {
                        userImg
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
