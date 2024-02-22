//
//  AstigmatismTest.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct AstigmatismView: View {
    @EnvironmentObject var router: Router

    @ObservedObject var viewModel = AstigmatismViewModel()
    @ObservedObject var profileViewModel = ProfileViewModel.shared

    var body: some View {
        VStack {
            CustomNavigationTitle(title: "난시 검사",
                                  isDisplayLeftButton: true)

            ExplanationTextView(str: "간단한 테스트를 통해\n난시 여부를 확인해보세요!")
                .padding(.leading, 20)
            Spacer()

            TestOnboardingView(image:[Image("Component1"), Image("Component2"), Image("Component5")], thirdTitle: "원의 중심으로 초점을 두고\n선의 변화를 확인하세요!")
                .padding(.horizontal, 10)
            Spacer()

            CustomButton(title: "테스트 시작하기",
                         background: .customGreen,
                         fontStyle: .pretendardBold_16,
                         action: {
                router.navigate(to: .distanceTest(title: "난시 검사", testType: .astigmatism))
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
    AstigmatismView()
}
