//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                        .font(.pretendardMedium_10)
                }
            MovementView()
                .tabItem {
                    Image(systemName: "eyes")
                    Text("눈운동")
                        .font(.pretendardMedium_10)
                }
            CommunityView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("게시판")
                        .font(.pretendardMedium_10)
                }
            EyeMapView()
                .tabItem {
                    Image(systemName: "map.fill")
                        .imageScale(.small)
                    Text("내주변")
                        .font(.pretendardMedium_10)
                }
        }
        .accentColor(.customGreen)
        .padding(0)
    }
}

#Preview {
    MainView()
}
