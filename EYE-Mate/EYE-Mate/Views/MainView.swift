//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct MainView: View {
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
        NavigationStack {
            CustomTabBarContainerView(selection: $tabSelection) {
                HomeView(tabSelection: $tabSelection)
                    .tabBarItem(tab: .home, selection: $tabSelection)
                MovementView()
                    .tabBarItem(tab: .movement, selection: $tabSelection)
                CommunityView()
                    .tabBarItem(tab: .community, selection: $tabSelection)
                EyeMapView()
                    .tabBarItem(tab: .eyeMap, selection: $tabSelection)
            }
        }
    }
}

#Preview {
    MainView()
}


