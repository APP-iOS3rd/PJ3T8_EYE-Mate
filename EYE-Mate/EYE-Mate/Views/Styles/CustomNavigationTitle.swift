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
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    
    init(title: String = "",
         isDisplayLeftButton: Bool = true
    ) {
        self.title = title
        self.isDisplayLeftButton = isDisplayLeftButton
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if isDisplayLeftButton {
                Button(action: { dismiss() },
                       label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 35))
                        .foregroundColor(.black)
                })
            }
            VStack(alignment: .leading) {
                Text("EYE-Mate")
                    .font(.pretendardSemiBold_22)
                Spacer()
                    .frame(height: 10)
                
                if title == "" {
                    HStack(spacing: 5) {
                        Text(userName)
                            .font(.pretendardSemiBold_32)
                            .foregroundColor(.customGreen)
                        
                        Text("님!")
                            .font(.pretendardBold_32)
                    }
                } else {
                    Text(title)
                        .font(.pretendardBold_32)
                }
            }
            Spacer()
            
            
            Button(action: {
                profileViewModel.isPresentedProfileView.toggle()
            }, label: {
                profileViewModel.profileImage
                    .ProfileImageModifier()
                    .frame(width: 50, height: 50)
            })
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

#Preview {
    CustomNavigationTitle(title: "시력 검사")
}
