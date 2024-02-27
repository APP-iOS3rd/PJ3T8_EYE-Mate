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

#Preview {
    MainView()
}


