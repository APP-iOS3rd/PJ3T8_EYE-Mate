//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = .init()
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                HomeView(selection: $selection)
                    .badge(10)
                    .tabItem {
                        Image(systemName: "house")
                        Text("홈")
                            .font(.pretendardMedium_10)
                    }.tag(0)
                MovementView()
                    .tabItem {
                        Image(systemName: "eyes")
                        Text("눈운동")
                            .font(.pretendardMedium_10)
                    }.tag(1)
                CommunityView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("게시판")
                            .font(.pretendardMedium_10)
                    }.tag(2)
                EyeMapView()
                    .tabItem {
                        Image(systemName: "map.fill")
                            .imageScale(.small)
                        Text("내주변")
                            .font(.pretendardMedium_10)
                    }.tag(3)
            }
            .accentColor(.customGreen)
            .padding(0)
        }
    }
}

#Preview {
    MainView()
}


