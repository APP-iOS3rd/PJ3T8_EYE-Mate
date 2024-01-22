//
//  ColorLiterals.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import Foundation
import SwiftUI

extension Color {
    // 회색배경 TextField
    static let textFieldGray = Color(hex: "#EEEEEE")
    // 회색 Btn
    static let btnGray  = Color(hex: "#DBDBDB")
    // 회색TabBar
    static let tabGray = Color(hex: "#C4C4C4")
    // 회색경고문구
    static let warningGray = Color(hex: "#8A8A8A")
    // 시그니처 컬러
    static let customGreen = Color(hex: "#52CAA6")
    // 대부분의 빨간색
    static let customRed = Color(hex: "#FF1A1A")
    // 기록부분 빨간색
    static let lightRed = Color(hex: "#FF6359")
    // 기록부분 노란색
    static let lightYellow = Color(hex: "#FFB647")
    // 그래프 남색
    static let graphIndigo = Color(hex: "#FFB647")
}

extension Color {
    init(hex: String) {
      let scanner = Scanner(string: hex)
      _ = scanner.scanString("#")
      
      var rgb: UInt64 = 0
      scanner.scanHexInt64(&rgb)
      
      let r = Double((rgb >> 16) & 0xFF) / 255.0
      let g = Double((rgb >>  8) & 0xFF) / 255.0
      let b = Double((rgb >>  0) & 0xFF) / 255.0
      self.init(red: r, green: g, blue: b)
    }
}
