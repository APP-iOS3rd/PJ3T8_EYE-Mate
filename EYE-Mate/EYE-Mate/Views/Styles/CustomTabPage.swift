//
//  CustomPageView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct CustomTabPage: View {
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.customGreen)
              UIPageControl.appearance().pageIndicatorTintColor = UIColor(.customGreen).withAlphaComponent(0.3)
           }
    
    var body: some View {
        TabView {
            // View
            Image(systemName: "figure.archery")
            
            Image(systemName: "figure.archery")
            
            Image(systemName: "figure.archery")
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .accentColor(.customGreen)
    }
}

#Preview {
    CustomTabPage()
}
