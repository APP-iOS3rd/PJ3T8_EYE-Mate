//
//  OnboardingView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct EyeSenseOnboardingView: View {
    @ObservedObject var onboardingViewModel: EyeSenseOnBoardingViewModel
    
    init(onboardingViewModel: EyeSenseOnBoardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.customGreen)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.customGreen).withAlphaComponent(0.3)
    }
    @State var showModal: Bool = false
    
    var body: some View {
        VStack{
            TabView{
                ForEach(onboardingViewModel.articles, id: \.self) { data in
                    NavigationLink(destination: EyeSenseView(url: data.url)){
                        VStack(alignment: .leading, spacing: 10){
                            EyeSenseTitleView()
                                .padding(.top, 15)
                                .padding(.leading, 15)
                            
                            HStack(alignment: .center) {
                                Spacer()
                                Text("\"\(data.title)\"")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .font(.pretendardSemiBold_18)
                                    .foregroundColor(.customGreen)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }
            }
            
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .accentColor(.customGreen)
            .frame(maxWidth: .infinity)
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
            Spacer()
        }
        .padding(.leading, 0)
    }
}


#Preview {
    EyeSenseOnboardingView(onboardingViewModel: EyeSenseOnBoardingViewModel(title: "현대인의 눈 피로 원인, 컴퓨터시력증후군(CVS)"))
}
