//
//  ColoredText.swift
//  EYE-Mate
//
//  Created by seongjun on 1/31/24.
//

import SwiftUI

struct ColoredText: View {
    let receivedText: String

    var body: some View {
        Text(receivedText)
            .foregroundColor(getTextColor())
            .font(.pretendardBold_28)
    }

    // 텍스트의 값에 따라 색상을 반환하는 함수
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
            case "나쁨":
                return Color.customRed
            case "양호":
                return Color.lightYellow
            case "좋음":
                return Color.customGreen
            default:
                return .black
            }
        }
    }

}

#Preview {
    ColoredText(receivedText: "0.5")
}
