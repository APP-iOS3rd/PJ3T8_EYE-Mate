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
        VStack{
            TabView{
                NavigationLink(destination: EyeSenseView()) {
                    VStack(alignment: .leading){
                        EyeSenseTitleView()
//                            .padding(.leading, 0)
                        
                        Text("\"\(onboardingViewModel.subTitle)\"")
                            .font(.pretendardMedium_18)
                            .foregroundColor(.customGreen)
                    }
                    .padding(.top, -20)
                }
                NavigationLink(destination: EyeSenseView()) {
                    VStack(alignment: .leading){
                        EyeSenseTitleView()
                            .padding(.leading, 0)
                        
                        Text("\"\(onboardingViewModel.subTitle)\"")
                            .font(.pretendardMedium_18)
                            .foregroundColor(.customGreen)
                    }
                    .padding(.top, -20)
                }
            }
            
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .accentColor(.customGreen)
//            .frame(maxWidth: .infinity)
            .frame(width: 350)
            .frame(height: 110)
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "EFFCFD"))
                    .opacity(0.8)
                    .shadow(radius: 4)
            }
        }
    }
}

struct EyeSenseTitleView: View {
    var body: some View {
        HStack (spacing: 10){
            Image("EyeSenseIcon")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("알고 계셨나요?")
                .font(.pretendardBold_16)
                .foregroundColor(.customGreen)
        }
        .padding(.leading, -30)
    }
}


#Preview {
    EyeSenseOnboardingView(onboardingViewModel: EyeSenseOnBoardingViewModel(title: "알고 계셨나요?", subTitle: "전자기기를 보면 눈이 안좋아져요!"))
}
