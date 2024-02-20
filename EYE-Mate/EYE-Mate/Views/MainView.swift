//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct MainView: View {
    @State private var tabSelection: TabBarItem = .home
    @State var eyeSenseOnBoardingViewModel = EyeSenseOnBoardingViewModel()
    var body: some View {
        NavigationStack {
            CustomTabBarContainerView(selection: $tabSelection) {
                HomeView(eyeSenseOnBoardingViewModel: eyeSenseOnBoardingViewModel, tabSelection: $tabSelection)
                    .tabBarItem(tab: .home, selection: $tabSelection)
                MovementView()
                    .tabBarItem(tab: .movement, selection: $tabSelection)
                CommunityView()
                    .tabBarItem(tab: .community, selection: $tabSelection)
                EyeMapView()
                    .tabBarItem(tab: .eyeMap, selection: $tabSelection)
            }
            .accentColor(.customGreen)
            .padding(0)
        }
    }
}

#Preview {
    MainView()
}


