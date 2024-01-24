//
//  VisionTest.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct VisionTestView: View {
    var body: some View {
        //TODO: - 커스텀 네비게이션 바
        CustomNavigationTitle(title: "시력 검사", userImg: Image(systemName: "person.fill"))
        //TODO: - 텍스트 뷰
        VisionTestTextView()
        Spacer()
        //TODO: - 온보딩 화면
        VisionTestOnboardingView(image:[Image("Component1"), Image("Component2"), Image("Component3")])
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

//MARK: - 텍스트 뷰
private struct VisionTestTextView: View {
    var body: some View {
        HStack {
            Text("간단한 테스트를 통해\n나의 시력을 확인해보세요!")
                .font(.pretendardRegular_24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            Spacer()
        }
        
    }
}

//MARK: - 테스트 시작 버튼
private struct StartBtn: View {
    
    fileprivate var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}


#Preview {
    VisionTestView()
}
