//
//  AddRecordSubtitleView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/5/24.
//

import SwiftUI

struct AddRecordSubtitleView: View {
    let label: String

    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 5, height: 18)
                .foregroundStyle(Color.customGreen)
            Text(label)
                .font(.pretendardRegular_18)
                .foregroundStyle(Color.darkGray)
            Spacer()
        }
    }
}

#Preview {
    AddRecordSubtitleView(label: "검사 날짜")
}
