//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct MainView: View {
    @StateObject private var tabManager = TabManager.shared
    
    @AppStorage("user_name") private var userName: String = "TestAccount"
    @AppStorage("user_UID") private var userUID: String = "mNnvAM9IlDdIu8fTZQpTICW37Np1"
    @AppStorage("user_profile_url") private var userProfileURL: String = "https://firebasestorage.googleapis.com:443/v0/b/eye-mate-29855.appspot.com/o/Profile_Images%2FmNnvAM9IlDdIu8fTZQpTICW37Np1.png?alt=media&token=b35d187d-d627-49d8-9c7c-33522d3697f1"
    @AppStorage("Login") var loggedIn: Bool = true
    @AppStorage("user_left") private var userLeft: String = ""
    @AppStorage("user_right") private var userRight: String = ""
    
    init(userName: String, userUID: String, userProfileURL: String, loggedIn: Bool, userLeft: String, userRight: String) {
        self.userName = userName
        self.userUID = userUID
        self.userProfileURL = userProfileURL
        self.loggedIn = loggedIn
        self.userLeft = userLeft
        self.userRight = userRight
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomNavigationTitle(isDisplayLeftButton: false)
                CustomTabBarContainerView() {
                    switch tabManager.selection {
                    case .home:
                        HomeView()
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
        .environmentObject(tabManager)
    }
}

class TabManager: ObservableObject {
    static let shared = TabManager()
    @Published var selection: TabBarItem = .home
}

//#Preview {
//    MainView()
//}
//

