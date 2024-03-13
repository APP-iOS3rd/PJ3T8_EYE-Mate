//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var tabManager: TabManager
    @State var eyeSenseOnBoardingViewModel = EyeSenseOnBoardingViewModel()

    @AppStorage("user_name") private var userName: String = "EYE-Mate"
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var userProfileURL: String = String.defaultProfileURL
    @AppStorage("Login") var loggedIn: Bool = false
    @AppStorage("user_left") var userLeft: String = ""
    @AppStorage("user_right") var userRight: String = ""
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared

    init(userName: String, userUID: String, userProfileURL: String, loggedIn: Bool, userLeft: String, userRight: String) {
        self.userName = userName
        self.userUID = userUID
        self.userProfileURL = userProfileURL
        self.loggedIn = loggedIn
        self.userLeft = userLeft
        self.userRight = userRight
        self.coordinator.checkIfLocationServiceIsEnabled()
    }
    
    var body: some View {
        VStack {
            CustomNavigationTitle(isDisplayLeftButton: false)
            CustomTabBarContainerView() {
                switch tabManager.selection {
                case .home:
                    HomeView(eyeSenseOnBoardingViewModel: eyeSenseOnBoardingViewModel)
                        .tabBarItem(tab: .home, selection: $tabManager.selection)
                case .movement:
                    MovementView()
                        .tabBarItem(tab: .movement, selection: $tabManager.selection)
                case .community:
                    CommunityView()
                        .tabBarItem(tab: .community, selection: $tabManager.selection)
                case .eyeMap:
                    EyeMapView()
                        .tabBarItem(tab: .eyeMap, selection: $tabManager.selection)
                }
            }
        }
    }
}

class TabManager: ObservableObject {
    @Published var selection: TabBarItem = .home
}

//#Preview {
//    MainView()
//}
