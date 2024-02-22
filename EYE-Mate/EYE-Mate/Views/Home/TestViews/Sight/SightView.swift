//
//  SightTest.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct SightView: View {
    @EnvironmentObject var router: Router

    @ObservedObject var viewModel = SightViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel.shared

    var body: some View {
        VStack {
            CustomNavigationTitle(title: "시야 검사",
                                  isDisplayLeftButton: true)
            .navigationDestination(isPresented: $profileViewModel.isPresentedProfileView) {
                ProfileView()
            }
            
            ExplanationTextView(str: "간단한 테스트를 통해\n시야의 상태를 확인해보세요!")
                .padding(.leading, 20)
            Spacer()
            
            TestOnboardingView(title: "핸드폰과 거리를\n30cm~40cm 떨어트려주세요!",
                               image:[Image("Component1"), Image("Component2"), Image("Component6")],
                               thirdTitle: "중앙에 있는 검은색 점에 초점을 두고\n선과 사각형의 변화를 확인하세요!")
            .padding(.horizontal, 10)
            Spacer()
            
            CustomButton(title: "테스트 시작하기",
                         background: .customGreen,
                         fontStyle: .pretendardBold_16,
                         action: {
                router.navigate(to: .distanceTest(title: "시야 검사", testType: .eyesight))
            })
            .frame(maxHeight: 75)
            Spacer()

            WarningText()
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    SightView()
}
