//
//  SightTest.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/23.
//

import SwiftUI

struct SightTestView: View {
    var body: some View {
        //TODO: - 커스텀 네비게이션 바
        CustomNavigationTitle(title: "시야 검사", userImg: Image(systemName: "person.fill"))
        //TODO: - 텍스트 뷰
        TestTextView(str: "간단한 테스트를 통해\n시야의 상태를 확인해보세요!")
        Spacer()
        //TODO: - 온보딩 화면
        VisionTestOnboardingView(image:[Image("Component1"), Image("Component2"), Image("Component6")], thirdTitle: "중앙에 있는 검은색 점에 초점을 두고\n선과 사각형의 변화를 확인하세요!")
        Spacer()
        //TODO: - 테스트 시작 버튼
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.customGreen)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .overlay{
                Button( action: {}, label: {
                    Text("테스트 시작하기")
                        .font(.pretendardBold_14)
                        .foregroundColor(.white)
                })
            }
            .padding(.horizontal, 15)
        Spacer()
        //TODO: - 경고 문구
        WaringText()
        Spacer()
    }
}

#Preview {
    SightTestView()
}
