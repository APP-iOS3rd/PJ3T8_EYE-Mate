//
//  NotificationManager.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/22.
//

import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    static let instance = NotificationManager()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                print("성공")
            }
        }
    }
    
    // localpush 내용
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "눈운동 할 시간이에요!"
        content.subtitle = "눈건강을 위해 EYE-Mate를 찾아주세요!"
        content.sound = .default
        content.badge = 1
        
        // 특정 시간
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func updateBadge() {
        DispatchQueue.main.async {
            let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount + 1
        }
    }
    
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
