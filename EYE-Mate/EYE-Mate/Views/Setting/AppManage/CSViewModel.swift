//
//  CustomerServiceViewModel.swift
//  EYE-Mate
//
//  Created by 이민영 on 2/24/24.
//

import SwiftUI
import SlackKit

enum CustomerServiceMenu {
    case report
    case error
    case inquiry

    enum Name: String {
        case report = "신고"
        case error = "오류"
        case inquiry = "문의/기타"
    }

    enum Code: String {
        case report = "C06LJG2U2EQ"
        case error = "C06L1FJ8KU7"
        case inquiry = "C06LEF0JZ9P"
    }
}

class CustomerServiceViewModel: ObservableObject {
    @AppStorage("user_UID") var userUID: String = ""
    
    func sendMessage(menu: CustomerServiceMenu.Name, text: String) {
        let bot = SlackKit()
        guard let token = Bundle.main.slackToken else { return }
        bot.addWebAPIAccessWithToken(token)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let content = "Date: \(dateFormatter.string(from: Date()))\n" + "userUID: \(userUID)\n" + "\(text)\n"
        
        bot.webAPI?.sendMessage(channel: getCode(for: menu), text: content, success: { response in
            print("Message sent successfully to \(menu): \(response)")
            
        }, failure: { error in
            print("Error sending message: \(error)")
        })
    }
    
    func getCode(for name: CustomerServiceMenu.Name) -> String {
        switch name {
        case .report:
            return CustomerServiceMenu.Code.report.rawValue
        case .error:
            return CustomerServiceMenu.Code.error.rawValue
        case .inquiry:
            return CustomerServiceMenu.Code.inquiry.rawValue
        }
    }
    
}
