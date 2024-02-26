////
////  Date+.swift
////  EYE-Mate
////
////  Created by Taejun Ha on 2/26/24.
////
//
import Foundation

extension Date {
    func isWithinOneMinute() -> Bool {
        let calendar = Calendar.current
        let oneMinuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        return self > oneMinuteAgo
    }
    
    func isWithinSevenDays() -> Bool {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return self > sevenDaysAgo
    }
}

extension Date {
    func getRelativeOrAbsoluteTime() -> String {
        if isWithinOneMinute() {
            return "방금 전"
        } else if isWithinSevenDays() {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            formatter.locale = Locale(identifier: "ko_KR") // 한국 로캘로 설정
            return formatter.localizedString(for: self, relativeTo: Date())
        } else {
            let dateFormatter = DateFormatter()
            let currentYear = Calendar.current.component(.year, from: Date())
            let year = Calendar.current.component(.year, from: self)
            
            if year != currentYear {
                dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            } else {
                dateFormatter.dateFormat = "MM월 dd일"
            }
            
            return dateFormatter.string(from: self)
        }
    }
}

