//
//  EYE_MateApp.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct EYE_MateApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

// firebase 연결함수
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
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
}
