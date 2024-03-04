//
//  DistanceConditionView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/26.
//

import SwiftUI

struct DistanceConditionView: View {
    @EnvironmentObject var router: Router

    var title: String
    var type: TestType

    init(title: String, type: TestType) {
        self.title = title
        self.type = type
    }

    var body: some View {
        ZStack {
            DistanceFaceAndDevice()
            BackgroundView()
            VStack {
                Spacer()
                    .frame(height: 5)
                HStack {
                    Text(title)
                        .frame(maxWidth: .infinity)
                        .font(.pretendardBold_24)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                router.navigateBack()
                            }, label: {
                                Image("close")
                            })
                            .padding(.trailing)
                        }
                }
                DistanceView(title: title, type: type)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - 설명 Text와 거리 Text View
private struct DistanceView: View {
    @EnvironmentObject var router: Router

    @StateObject var viewModel = DistanceConditionViewModel.shared
    @ObservedObject var visionTestViewModel = VisionTestViewModel.shared
    var title: String
    var type: TestType
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 100)

            if type != .eyesight {
                Text("\(title)를 위해서 휴대폰을 사용자와\n40cm ~ 50cm 간격을 유지해주세요!")
                    .font(.pretendardMedium_20)
                    .multilineTextAlignment(.center)
            } else {
                Text("\(title)를 위해서 휴대폰을 사용자와\n30cm ~ 40cm 간격을 유지해주세요!")
                    .font(.pretendardMedium_20)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            HStack{
                Spacer()
                Text("현재 거리 ")
                    .font(.pretendardRegular_30)
                if type != .eyesight {
                    Text("\(viewModel.distance)")
                        .font(.pretendardRegular_40)
                        .foregroundColor(viewModel.canStart ? .customGreen : .customRed)
                } else {
                    Text("\(viewModel.distance)")
                        .font(.pretendardRegular_40)
                        .foregroundColor(viewModel.canSightStart ? .customGreen : .customRed)
                }
                Text("CM")
                    .font(.pretendardRegular_30)
                Spacer()
            }

            Spacer()

            VStack {
                if type != .eyesight {
                    Text(viewModel.informationText)
                        .font(.pretendardMedium_20)
                        .foregroundColor(viewModel.canStart ? .customGreen : .customRed)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)

                    CustomButton(title: "테스트 시작하기", background: viewModel.canStart ? .customGreen : .buttonGray, fontStyle: .pretendardMedium_18, action: {
                        switch type {
                        case .vision:
                            visionTestViewModel.userDistance = viewModel.distance
                            router.navigate(to: .visionTest)
                        case .astigmatism:
                            router.navigate(to: .astigmatismTest)
                        case .eyesight:
                            router.navigate(to: .sightTest)
                        case .colorVision:
                            break
                        }
                    })
                    .frame(maxHeight: 75)
                    .disabled(!viewModel.canStart)
                } else {
                    Text(viewModel.sightInformationText)
                        .font(.pretendardMedium_20)
                        .foregroundColor(viewModel.canSightStart ? .customGreen : .customRed)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                    CustomButton(title: "테스트 시작하기", background: viewModel.canSightStart ? .customGreen : .buttonGray, fontStyle: .pretendardMedium_18, action: {
                        switch type {
                        case .vision:
                            router.navigate(to: .visionTest)
                        case .astigmatism:
                            router.navigate(to: .astigmatismTest)
                        case .eyesight:
                            router.navigate(to: .sightTest)
                        case .colorVision:
                            break
                        }
                    })
                    .frame(maxHeight: 75)
                    .disabled(type != .eyesight ? !viewModel.canStart : !viewModel.canSightStart)
                }
            }
        }
    }
}




#Preview {
    DistanceConditionView(title: "검사", type: .vision)
}
