//
//  ContentView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/22.
//

import SwiftUI

struct Main: View {

    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                        .font(.pretendardMedium_10)
                }
            Movement()
                .tabItem {
                    Image(systemName: "eyes")
                    Text("눈운동")
                        .font(.pretendardMedium_10)
                }
            Community()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("게시판")
                        .font(.pretendardMedium_10)
                }
            EyeMap()
                .tabItem {
                    Image(systemName: "map")
                    Text("내주변")
                        .font(.pretendardMedium_10)
                }
        }
        .font(.headline)
        .accentColor(.customGreen)
    }
}

#Preview {
    Main()
}
