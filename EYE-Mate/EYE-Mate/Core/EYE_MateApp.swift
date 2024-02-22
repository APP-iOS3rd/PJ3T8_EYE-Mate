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
            MainView(userName: "TestAccount", userUID: "mNnvAM9IlDdIu8fTZQpTICW37Np1", userProfileURL: "https://firebasestorage.googleapis.com:443/v0/b/eye-mate-29855.appspot.com/o/Profile_Images%2FmNnvAM9IlDdIu8fTZQpTICW37Np1.png?alt=media&token=b35d187d-d627-49d8-9c7c-33522d3697f1",
                     loggedIn: true, userLeft: "", userRight: "")
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
