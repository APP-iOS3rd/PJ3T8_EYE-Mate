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
    
    init(title: String, userImg: Image) {
        self.title = title
        self.userImg = userImg
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("EYE-Mate")
                    .font(.pretendardSemiBold_22)
                
                HStack {
                    Text(title)
                        .font(.pretendardBold_32)
                    
                    Spacer()
                    
                    NavigationLink(destination: ProfileView()) {
                        userImg
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                    }
                }
            }
            .padding([.leading, .trailing], 20)
    }
}

#Preview {
    CustomNavigationTitle(title: "홈", userImg: Image("person.fill"))
}
