//
//  TestTextView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/24.
//

import SwiftUI

struct ExplanationTextView: View {
    var str: String
    
    init(str: String) {
        self.str = str
    }
    
    var body: some View {
        HStack {
            Text(str)
                .font(.pretendardRegular_24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            Spacer()
        }
    }
}

#Preview {
    ExplanationTextView(str: "테스트")
}
