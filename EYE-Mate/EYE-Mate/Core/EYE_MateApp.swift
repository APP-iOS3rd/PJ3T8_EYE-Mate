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
    @ObservedObject private var router = Router()
    @ObservedObject private var tabManager = TabManager()
    
    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    @AppStorage("Login") var loggedIn: Bool = false
    @AppStorage("user_left") var userLeft: String = ""
    @AppStorage("user_right") var userRight: String = ""

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navigationPath) {
                MainView(userName: self.userName, userUID: self.userUID, userProfileURL: self.userProfileURL, loggedIn: self.loggedIn, userLeft: self.userLeft, userRight: self.userRight)
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
                        case .eyeSense(let url):
                            EyeSenseView(url: url)
                        }
                    }
            }
            .environmentObject(router)
            .environmentObject(tabManager)
        }
    }
}
