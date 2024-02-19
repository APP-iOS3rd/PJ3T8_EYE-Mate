//
//  ColorTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct ColorView: View {
    @StateObject var viewModel = SightViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            CustomNavigationTitle(title: "색채 검사",
                                  isDisplayLeftButton: true,
                                  leftButtonAction: { dismiss() },
                                  profileButtonAction: {
                viewModel.isPresentedProfileView.toggle()
            })
            .navigationDestination(isPresented: $viewModel.isPresentedProfileView) {
                ProfileView()
            }
            
            ExplanationTextView(str: "간단한 테스트를 통해\n색채 식별도를 확인해보세요!")
            
            Spacer()
            
            TestOnboardingView(image:[Image("Component1"), Image("Component4")])
                .padding(.horizontal, 10)
            
            Spacer()
            
            CustomButton(title: "테스트 시작하기",
                         background: .customGreen,
                         fontStyle: .pretendardBold_16,
                         action: {
                viewModel.isPresentedTestView.toggle()
            })
            .navigationDestination(isPresented: $viewModel.isPresentedTestView) {
                ColorTestView()
            }
            .frame(maxHeight: 75)
            
            Spacer()
            
            WarningText()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ColorView()
}
