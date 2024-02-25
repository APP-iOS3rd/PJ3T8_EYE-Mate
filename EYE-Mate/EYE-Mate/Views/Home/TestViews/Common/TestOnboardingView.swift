//
//  VisionTestOnboardingView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/24.
//

import SwiftUI

struct TestOnboardingView: View {
    var title: String
    var img: [Image]
    var thirdTitle: String
    
    init(title: String = "핸드폰과 거리를\n40cm~50cm 떨어트려주세요!", image: [Image], thirdTitle: String = "") {
        self.title = title
        self.img = image
        self.thirdTitle = thirdTitle
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.customGreen)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.customGreen).withAlphaComponent(0.3)
    }
    
    var body: some View {
        if img.count == 2 {
            TabView {
                VStack {
                    Spacer()
                    Text(title)
                        .multilineTextAlignment(.center)
                        .font(.pretendardRegular_24)
                    Spacer()
                    img[0]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 3)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 1, y: 1)
                        
                )
                .padding()
                .padding(.bottom, 30)
                
                
                VStack {
                    Spacer()
                    img[1]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 3)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 1, y: 1)
                )
                .padding()
                .padding(.bottom, 30)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .accentColor(.customGreen)
            .onDisappear{
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.white)
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(.white).withAlphaComponent(0.3)
            }
        } else {
            TabView {
                VStack {
                    Spacer()
                    Text(title)
                        .multilineTextAlignment(.center)
                        .font(.pretendardRegular_24)
                    Spacer()
                    img[0]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 3)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 1, y: 1)
                )
                .padding()
                .padding(.bottom, 30)
                
                
                VStack {
                    Spacer()
                    Text("오른쪽 눈을 먼저 검사해요!")
                        .font(.pretendardRegular_24)
                    Spacer()
                    img[1]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 40)
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 3)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 1, y: 1)
                )
                .padding()
                .padding(.bottom, 30)
                
                
                VStack {
                    Spacer()
                    Text(thirdTitle)
                        .multilineTextAlignment(.center)
                        .font(.pretendardRegular_20)
                    Spacer()
                    img[2]
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.customGreen, lineWidth: 3)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 1, y: 1)
                )
                .padding()
                .padding(.bottom, 30)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .accentColor(.customGreen)
            .onDisappear{
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.white)
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(.white).withAlphaComponent(0.3)
            }
        }
    }
}

#Preview {
    TestOnboardingView(image: [Image("Component1"), Image("Component2"), Image("Component3")])
}
