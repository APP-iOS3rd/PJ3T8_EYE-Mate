//
//  OnboardingView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct EyeSenseOnboardingView: View {
    var onboardingViewModel: EyeSenseOnBoardingViewModel
    
    init(onboardingViewModel: EyeSenseOnBoardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.customGreen)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.customGreen).withAlphaComponent(0.3)
    }
    
    var body: some View {
        TabView{
            NavigationLink(destination: EyeSenseView()) {
                VStack{
                    Text(onboardingViewModel.title)
                        .font(.pretendardBold_16)
                        .foregroundColor(.customGreen)
                    Spacer()
                        .frame(height: 5)
                    Text(onboardingViewModel.subTitle)
                        .font(.pretendardMedium_20)
                        .foregroundColor(.customGreen)
                }
            }
            NavigationLink(destination: EyeSenseView()) {
                VStack{
                    Text(onboardingViewModel.title)
                        .font(.pretendardBold_16)
                        .foregroundColor(.customGreen)
                    Spacer()
                        .frame(height: 5)
                    Text(onboardingViewModel.subTitle)
                        .font(.pretendardMedium_20)
                        .foregroundColor(.customGreen)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        .accentColor(.customGreen)
    }
}

#Preview {
    EyeSenseOnboardingView(onboardingViewModel: EyeSenseOnBoardingViewModel(title: "오늘의 눈 상식", subTitle: "전자기기를 보면 눈이 안좋아져요!"))
}
