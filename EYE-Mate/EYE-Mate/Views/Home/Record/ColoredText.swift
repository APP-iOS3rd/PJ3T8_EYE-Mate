//
//  ColoredText.swift
//  EYE-Mate
//
//  Created by seongjun on 1/31/24.
//

import SwiftUI

struct ColoredText: View {
    let receivedText: String
    let font: Font

    var body: some View {
        Text(receivedText)
            .foregroundColor(getTextColor())
            .font(font)
    }

    /// 텍스트의 값에 따라 색상을 반환하는 함수
    func getTextColor() -> Color {
        if let doubleText = Double(receivedText) {
            switch doubleText {
            case ...0.3:
                return Color.customRed
            case 0.3..<0.8:
                return Color.lightYellow
            case 0.8...:
                return Color.customGreen
            default:
                return .black
            }
        } else {
            switch receivedText {
            case "나쁨", "심각한 색채 지각 이상":
                return Color.customRed
            case "양호", "경미한 색채 지각 이상", "중증도의 색채 지각 이상":
                return Color.lightYellow
            case "좋음", "정상적인 색채 지각":
                return Color.customGreen
            default:
                return .black
            }
        }
    }

}

#Preview {
    ColoredText(receivedText: "0.5", font: .pretendardBold_28)
}
