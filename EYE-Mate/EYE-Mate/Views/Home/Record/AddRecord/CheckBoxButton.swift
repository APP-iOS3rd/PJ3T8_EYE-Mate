//
//  CheckBoxButton.swift
//  EYE-Mate
//
//  Created by seongjun on 2/2/24.
//

import SwiftUI

struct CheckBoxButton: View {
    let id: String
    let label: String
    let isMarked: Bool
    let callback: (String)->()

    init(
        id: String,
        label: String,
        isMarked: Bool = false,
        callback: @escaping (String)->()
    ) {
        self.id = id
        self.label = label
        self.isMarked = isMarked
        self.callback = callback
    }

    var body: some View {
        Button {
            self.callback(self.id)
        } label: {
            if self.isMarked {
                Text(label)
                    .font(.pretendardSemiBold_16)
                    .foregroundStyle(.white)
                    .padding(16)
                    .frame(height: 32)
                    .background(Color.customGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.buttonGray, lineWidth: 1)
                    } }
            else {
                Text(label)
                    .font(.pretendardRegular_16)
                    .foregroundStyle(Color.buttonGray)
                    .padding(16)
                    .frame(height: 32)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.buttonGray, lineWidth: 1)
                    }
            }
        }
    }
}

#Preview {
    CheckBoxButton(id: "안경", label: "안경") { _ in

    }
}
