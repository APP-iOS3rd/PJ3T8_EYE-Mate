//
//  AppDelegate.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/02/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications

// firebase 연결함수
class AppDelegate: NSObject, UIApplicationDelegate {
    
    let notificationManager = NotificationManager.instance
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        notificationManager.removeAllNotifications()
        
        
        // 권한 요청
        notificationManager.requestAuthorization { granted in
            if granted {
                self.notificationManager.scheduleNotification()
            }
        }
        
        return true
    }
    
    // 토큰 받아오는 함수
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 사용자의 데이터 보내기
        // 우선 nodata로 아무것도 안보냄
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url){
            return true
        }
        return false
    }

    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 알림이 도착했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}
