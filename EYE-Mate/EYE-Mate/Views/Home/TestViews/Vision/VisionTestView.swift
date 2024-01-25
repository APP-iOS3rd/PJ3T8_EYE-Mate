//
//  VisionTest.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct VisionTestView: View {
    @State private var isPresentedTestView: Bool = false
    var body: some View {
        //TODO: - 커스텀 네비게이션 바
        NavigationStack{
            CustomNavigationTitle(title: "시력 검사", userImg: Image(systemName: "person.fill"))
            //TODO: - 텍스트 뷰
            ExplanationTextView(str: "간단한 테스트를 통해\n나의 시력을 확인해보세요!")
            Spacer()
            //TODO: - 온보딩 화면
            VisionTestOnboardingView(image:[Image("Component1"), Image("Component2"), Image("Component3")])
            Spacer()
            //TODO: - 테스트 시작 버튼
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.customGreen)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .overlay{
                    Button( action: {
                        isPresentedTestView.toggle()
                        print(isPresentedTestView)
                    }, label: {
                        Text("테스트 시작하기")
                            .font(.pretendardBold_14)
                            .foregroundColor(.white)
                    })
                    .navigationDestination(isPresented: $isPresentedTestView) {
                        VisionTestConditionView()
                    }
                }
                .padding(.horizontal, 15)
            Spacer()
            //TODO: - 경고 문구
            WaringText()
            Spacer()
        }
    }
}

#Preview {
    VisionTestView()
}
