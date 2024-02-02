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
    let callback: (String, Bool)->()

    init(
        id: String,
        label:String,
        callback: @escaping (String, Bool)->()
        ) {
        self.id = id
        self.label = label
        self.callback = callback
    }

    @State var isMarked: Bool = false

    var body: some View {
        Button {
            self.isMarked.toggle()
            self.callback(self.id, self.isMarked)
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
                            .stroke(Color.btnGray, lineWidth: 1)
                    } }
            else {
                Text(label)
                    .font(.pretendardRegular_16)
                    .foregroundStyle(Color.btnGray)
                    .padding(16)
                    .frame(height: 32)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.btnGray, lineWidth: 1)
                    }
            }
        }
    }
}

#Preview {
    CheckBoxButton(id: "안경", label: "안경") { _, _  in

    }
}
