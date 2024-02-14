//
//  CustomMenu.swift
//  EYE-Mate
//
//  Created by seongjun on 2/6/24.
//

import SwiftUI

struct CustomMenu<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(.white)
        .cornerRadius(10)
        .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
    }
}

struct CustomMenuButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
        .foregroundColor(color)
        .background(configuration.isPressed ? Color.btnGray : Color.clear)

    }
}

#Preview {
    CustomMenu {
        Group {
              Button(action: {}) {
                  Text("좋음")
              }
              .buttonStyle(CustomMenuButtonStyle(color: Color.customGreen))
            HorizontalDivider(color: Color.btnGray, height: 2).padding(.horizontal, 12)
              Button(action: {}) {
                  Text("양호")
              }
              .buttonStyle(CustomMenuButtonStyle(color: Color.lightYellow))
            HorizontalDivider(color: Color.btnGray, height: 2).padding(.horizontal, 12)
              Button(action: {}) {
                  Text("나쁨")
              }
              .buttonStyle(CustomMenuButtonStyle(color: Color.customRed))
          }
    }.frame(width: 108)
}
