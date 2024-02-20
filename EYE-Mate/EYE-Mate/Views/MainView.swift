//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct MainView: View {
    @StateObject private var tabManager = TabManager()
    @State var eyeSenseOnBoardingViewModel = EyeSenseOnBoardingViewModel()
  
    var body: some View {
        NavigationStack {
            CustomTabBarContainerView() {
                HomeView(eyeSenseOnBoardingViewModel: eyeSenseOnBoardingViewModel)
                    .tabBarItem(tab: .home, selection: $tabManager.selection)
                MovementView()
                    .tabBarItem(tab: .movement, selection: $tabManager.selection)
                CommunityView()
                    .tabBarItem(tab: .community, selection: $tabManager.selection)
                EyeMapView()
                    .tabBarItem(tab: .eyeMap, selection: $tabManager.selection)
            }
            .accentColor(.customGreen)
        }
        .environmentObject(tabManager)
    }
}

class TabManager: ObservableObject {
    @Published var selection: TabBarItem = .home
}

#Preview {
    MainView()
}


