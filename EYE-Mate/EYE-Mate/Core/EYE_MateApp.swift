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
                 MainView(userName: "TestAccount", userUID: "mNnvAM9IlDdIu8fTZQpTICW37Np1", userProfileURL: "https://firebasestorage.googleapis.com:443/v0/b/eye-mate-29855.appspot.com/o/Profile_Images%2FmNnvAM9IlDdIu8fTZQpTICW37Np1.png?alt=media&token=b35d187d-d627-49d8-9c7c-33522d3697f1",
                     loggedIn: true, userLeft: "", userRight: "")
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
        }
    }
}
