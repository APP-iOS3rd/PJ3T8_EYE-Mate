//
//  VisionTest.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct VisionView: View {
    @EnvironmentObject var router: Router

    @ObservedObject var profileViewModel = ProfileViewModel.shared

    var body: some View {
        VStack {
            CustomNavigationTitle(title: "시력 검사",
                                  isDisplayLeftButton: true)

            .navigationDestination(isPresented: $profileViewModel.isPresentedProfileView) {
                ProfileView()
            }

            ExplanationTextView(str: "간단한 테스트를 통해\n나의 시력을 확인해보세요!")
                .padding(.leading, 20)
            Spacer()

            TestOnboardingView(image:[Image("Component1"), Image("Component2"), Image("Component3")])
                .padding(.horizontal, 10)
            Spacer()

            CustomButton(title: "테스트 시작하기",
                         background: .customGreen,
                         fontStyle: .pretendardBold_16,
                         action: {
                router.navigate(to: .distanceTest(title: "시력 검사", testType: .vision))
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
    VisionView()
}
