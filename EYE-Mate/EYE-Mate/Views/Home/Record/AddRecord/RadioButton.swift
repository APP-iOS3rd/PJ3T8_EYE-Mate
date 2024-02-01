//
//  RadioButton.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

struct RadioButton: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked: Bool
    let callback: (String)->()

    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.black,
        textSize: CGFloat = 14,
        isMarked: Bool = true,
        callback: @escaping (String)->()
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }

    var body: some View {
        //        Button(action:{
        //            self.callback(self.id)
        //        }) {
        //            HStack(alignment: .center, spacing: 10) {
        //                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
        //                    .renderingMode(.original)
        //                    .resizable()
        //                    .aspectRatio(contentMode: .fit)
        //                    .frame(width: self.size, height: self.size)
        //                Text(label)
        //                    .font(Font.system(size: textSize))
        //                Spacer()
        //            }.foregroundColor(self.color)
        //        }
        //        .foregroundColor(Color.white)
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
    RadioButton(id: "안경", label: "안경") { _ in

    }
}
