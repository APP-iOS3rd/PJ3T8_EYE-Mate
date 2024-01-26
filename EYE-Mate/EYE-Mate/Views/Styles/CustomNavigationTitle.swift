//
//  CustomNavigationTitle.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct CustomNavigationTitle: View {
    var title: String
    var userImg: Image
    
    init(title: String, userImg: Image = Image(systemName: "person.fill")) {
        self.title = title
        self.userImg = userImg
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack {
                    Text("EYE-Mate")
                        .font(.pretendardSemiBold_22)
                    Text(title)
                        .font(.pretendardBold_32)
                }
                Spacer()
                
                NavigationLink(destination: ProfileView()) {
                    userImg
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            .padding([.leading, .trailing], 20)
        }
    }
}

#Preview {
    CustomNavigationTitle(title: "홈")
}
