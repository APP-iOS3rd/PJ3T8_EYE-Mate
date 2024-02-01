//
//  VisionTest.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct VisionView: View {
    @ObservedObject var viewModel = VisionViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            CustomNavigationTitle(title: "시력 검사",
                                  userImgUrl: "",
                                  isDisplayBtn: true,
                                  leftBtnAction: { dismiss() },
                                  profileBtnAction: {
                viewModel.isPresentedProfileView.toggle()
            })
            .navigationDestination(isPresented: $viewModel.isPresentedProfileView) {
                ProfileView()
            }
            
            ExplanationTextView(str: "간단한 테스트를 통해\n나의 시력을 확인해보세요!")
                .padding(.leading, 20)
            
            Spacer()
            
            VisionTestOnboardingView(image:[Image("Component1"), Image("Component2"), Image("Component3")])
            
            Spacer()
            
            CustomBtn(title: "테스트 시작하기",
                      background: .customGreen,
                      fontStyle: .pretendardBold_16,
                      action: {
                viewModel.isPresentedTestView.toggle()
            })
            .navigationDestination(isPresented: $viewModel.isPresentedTestView, destination: {
                DistanceConditionView(title: "시력 검사", type: .vision)
            })
            .frame(maxHeight: 75)
            
            Spacer()
            
            WaringText()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    VisionView()
}
