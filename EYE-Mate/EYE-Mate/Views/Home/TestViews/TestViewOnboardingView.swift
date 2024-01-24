//
//  VisionTestOnboardingView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/24.
//

import SwiftUI

struct VisionTestOnboardingView: View {
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
                GeometryReader { geometry in
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
                    .frame(width: geometry.size.width / 1.12, height: geometry.size.height / 1.1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customGreen, lineWidth: 3)
                            .foregroundColor(.white)
                            .frame(width: .infinity)
                            .shadow(radius: 3, x: 1, y: 1)
                    )
                    .padding(.leading, 20)
                    .padding(.vertical)
                }
                
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        img[1]
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        Spacer()
                    }
                    .frame(width: geometry.size.width / 1.12, height: geometry.size.height / 1.1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customGreen, lineWidth: 3)
                            .foregroundColor(.white)
                            .frame(maxHeight: 436)
                            .shadow(radius: 3, x: 1, y: 1)
                    )
                    .padding(.leading, 20)
                    .padding(.vertical)
                }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .accentColor(.customGreen)
        } else {
            TabView {
                GeometryReader { geometry in
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
                    .frame(width: geometry.size.width / 1.12, height: geometry.size.height / 1.1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customGreen, lineWidth: 3)
                            .foregroundColor(.white)
                            .frame(width: .infinity)
                            .shadow(radius: 3, x: 1, y: 1)
                    )
                    .padding(.leading, 20)
                    .padding(.vertical)
                }
                
                GeometryReader { geometry in
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
                    .frame(width: geometry.size.width / 1.12, height: geometry.size.height / 1.1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customGreen, lineWidth: 3)
                            .foregroundColor(.white)
                            .frame(width: .infinity)
                            .shadow(radius: 3, x: 1, y: 1)
                    )
                    .padding(.leading, 20)
                    .padding(.vertical)
                }
                
                GeometryReader { geometry in
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
                    .frame(width: geometry.size.width / 1.12, height: geometry.size.height / 1.1)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customGreen, lineWidth: 3)
                            .foregroundColor(.white)
                            .frame(width: .infinity)
                            .shadow(radius: 3, x: 1, y: 1)
                    )
                    .padding(.leading, 20)
                    .padding(.vertical)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .accentColor(.customGreen)
        }
    }
}

#Preview {
    VisionTestOnboardingView(image: [Image("Component1"), Image("Component2"), Image("Component3")])
}
