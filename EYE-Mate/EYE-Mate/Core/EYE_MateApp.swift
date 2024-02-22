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
    @ObservedObject var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navigationPath) {
                MainView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .record:
                            RecordView()
                        case .allRecord(let recordType):
                            AllRecordView(recordType: recordType)
                        case .addRecord:
                            AddRecordView()
                        case .movementLottie(let movementType):
                            MovementLottieView(movementType: movementType)
                        case .checkVision:
                            VisionView()
                        case .checkColor:
                            ColorView()
                        case .checkAstigmatism:
                            AstigmatismView()
                        case .checkSight:
                            SightView()
                        case .distanceTest(title: let title, testType: let testType):
                            DistanceConditionView(title: title, type: testType)
                        case .colorTest:
                            ColorTestView()
                        case .visionTest:
                            VisionTestView()
                        case .astigmatismTest:
                            AstigmatismTestView()
                        case .sightTest:
                            SightTestView()
                        case .profile:
                            ProfileView()
                        case .signUpProfile:
                            SignUpProfileView()
                        }
                    }
            }
            .environmentObject(router)
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

    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
