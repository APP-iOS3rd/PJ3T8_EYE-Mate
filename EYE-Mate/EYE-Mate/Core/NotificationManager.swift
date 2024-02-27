//
//  NotificationManager.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/22.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager {
    static let instance = NotificationManager()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("error: \(error)")
                completion(false)
            } else {
                print("성공")
                completion(true)
            }
        }
    }
    
    // localpush 내용
    func scheduleNotification() {
        print("scheduleNotification called")
        
        let content = UNMutableNotificationContent()
        content.title = "눈운동 할 시간이에요!"
        content.body = "눈건강을 위해 EYE-Mate를 찾아주세요!"
        content.sound = .default
        
        // 특정 시간
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // 테스트용 알림 시간
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}
