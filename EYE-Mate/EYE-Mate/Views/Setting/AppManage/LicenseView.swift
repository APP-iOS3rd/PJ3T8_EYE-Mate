//
//  LicenseView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/22.
//

import SwiftUI

struct LicenseView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            SettingNavigationTitle(isDisplayTitle: true, leftBtnAction: {
                presentationMode.wrappedValue.dismiss()
            }, leftBtnType: .back, title: "라이센스")
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Icon")
                        .font(.pretendardSemiBold_18)
                    
                    Text("designed by Freepik from Flaticon")
                        .font(.pretendardMedium_16)
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    Text("Pictures")
                        .font(.pretendardSemiBold_18)
                    Text("색각 - S. Ishihara, Tests for colour-blindness")
                        .font(.pretendardMedium_16)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: UIScreen.main.bounds.width)

            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    LicenseView()
}
