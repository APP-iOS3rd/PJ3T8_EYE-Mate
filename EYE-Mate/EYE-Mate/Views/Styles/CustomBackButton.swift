//
//  CustomBackButton.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/02/16.
//

import SwiftUI

struct CustomBackButton: View {
    @EnvironmentObject var router: Router

    var body: some View {
        HStack(alignment: .bottom) {
            Button {
                router.navigateBack()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .padding(.top, 10)
        .padding(.leading, 20)
    }
}

#Preview {
    CustomBackButton()
}
