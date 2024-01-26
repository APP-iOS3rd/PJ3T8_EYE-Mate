//
//  VisionTestConditionView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/25.
//

import SwiftUI

struct VisionTestConditionView: View {
    @ObservedObject var viewModel = VisionTestConditionViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                DistanceFaceAndDevice(model: viewModel)
                GeometryReader { g in
                    Rectangle()
                        .ignoresSafeArea()
                        .frame(width: g.size.width, height: g.size.height)
                        .foregroundColor(.white)
                }
                VStack {
                    //TODO: - Custom 상단바 구현
                    Spacer()
                        .frame(maxHeight: 100)
                    Text("시력검사를 위해서 휴대폰을 사용자와\n40cm ~ 50cm 간격을 유지해주세요!")
                        .font(.pretendardMedium_20)
                        .multilineTextAlignment(.center)
                    Spacer()
                    HStack{
                        Spacer()
                        Text("현재거리 ")
                            .font(.pretendardRegular_30)
                        Text("\(viewModel.distance)")
                            .font(.pretendardRegular_40)
                            .foregroundColor(viewModel.canStart ? .customGreen : .customRed)
                        Text("CM")
                            .font(.pretendardRegular_30)
                        Spacer()
                    }
                    Spacer()
                    // 만약 거리가 40~50cm 이내라면
                    //TODO: - 테스트가 가능한지 안가능한지 여부 Text + 여부에 따라 버튼 활성화 및 비활성화
                    VStack {
                        Text(viewModel.canStart ? "테스트가 가능합니다." : "테스트 가능한 거리가 되면\n버튼이 활성화됩니다.")
                            .font(.pretendardMedium_20)
                            .foregroundColor(viewModel.canStart ? .customGreen : .customRed)
                            .multilineTextAlignment(.center)
                            .frame(height: 50)
                        CustomBtn(title: "테스트 시작하기", background: viewModel.canStart ? .customGreen : .btnGray, fontStyle: .pretendardMedium_18, action: {})
                            .frame(maxHeight: 75)
                            .disabled(!viewModel.canStart)
                    }
                    
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("시력 검사")
                            .font(.pretendardBold_24)
                    }
                    ToolbarItem {
                        Button(action: {
                            
                        }, label: {
                            Image("close")
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    VisionTestConditionView()
}
