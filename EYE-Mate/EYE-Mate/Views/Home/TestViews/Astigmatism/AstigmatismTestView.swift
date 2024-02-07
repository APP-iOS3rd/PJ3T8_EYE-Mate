//
//  AstigmatismTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct AstigmatismTestView: View {
    @StateObject var viewModel = AstigmatismTestViewModel()
    @ObservedObject var distance: DistanceConditionViewModel
    
    //MARK: - 테스트용으로 true로 설정, 기본값은 false
    @State var isTestComplete: Bool = false
    
    var body: some View {
        VStack {
            if !isTestComplete {
                AstigmatismTest(viewModel: viewModel,
                                distance: distance,
                                isTestComplete: $isTestComplete)
            } else {
                AstigmatismTestResultView(viewModel: viewModel)
            }
        }
    }
}

//MARK: - 테스트 화면
private struct AstigmatismTest: View {
    @ObservedObject var viewModel: AstigmatismTestViewModel
    @ObservedObject var distance: DistanceConditionViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var isTestComplete: Bool
    @State var testPercent = 0.0
    @State var isChange: Bool = false
    
    var body: some View {
        VStack {
            if !isChange {
                //TODO: - 오른쪽 눈 시야 검사
                AstigmatismRight(viewModel: viewModel,
                                 distance: distance,
                                 testPercent: $testPercent,
                                 isChange: $isChange)
            } else {
                //TODO: - 왼쪽 눈 시야검사
                AstigmatismLeft(viewModel: viewModel,
                                distance: distance,
                                testPercent: $testPercent,
                                isTestComplete: $isTestComplete)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("난시 검사")
                    .font(.pretendardBold_24)
            }
            ToolbarItem {
                Button(action: {
                    dismiss()
                }, label: {
                    Image("close")
                })
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - 오른쪽 눈 화면
private struct AstigmatismRight: View {
    @ObservedObject var viewModel: AstigmatismTestViewModel
    @ObservedObject var distance: DistanceConditionViewModel
    @Binding var testPercent: Double
    @Binding var isChange: Bool
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
            //TODO: - 테스트 안내문구 보여주기
            ProgressView(value: testPercent)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))
            
            Spacer()
            
            VStack {
                Text("난시 검사를 시작합니다.")
                    .font(.pretendardMedium_22)
                HStack(spacing: 5) {
                    Text("왼쪽 눈을 감고")
                        .font(.pretendardBold_22)
                    Text("준비되면")
                        .font(.pretendardMedium_22)
                }
                Text("버튼을 눌러주세요!")
                    .font(.pretendardMedium_22)
            }
            
            Spacer()
            
            Image("Component7")
            
            Spacer()
            
            CustomButton(title: "다음",
                         background: .customGreen,
                         fontStyle: .pretendardMedium_18,
                         action: {
                isReady = true
            })
            .frame(maxHeight: 75)
        } else {
            //TODO: - 테스트 화면 보여주기
            VStack {
                NavigationStack {
                    ZStack {
                        DistanceFaceAndDevice(model: distance)
                        BackgroundView()
                        VStack {
                            ProgressView(value: testPercent)
                                .progressViewStyle(LinearProgressViewStyle(tint: .customGreen))
                            HStack(alignment: .lastTextBaseline) {
                                Spacer()
                                Text("현재거리 ")
                                    .font(.pretendardRegular_30)
                                Text("\(distance.distance)")
                                    .font(.pretendardRegular_40)
                                    .foregroundColor(distance.canStart ? .customGreen : .customRed)
                                Text("CM")
                                    .font(.pretendardRegular_30)
                                Spacer()
                            }
                            Spacer()
                            
                            Image("Component5")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Spacer()
                            
                            Text("원의 중심에 초점을 맞추세요.\n모든 선이 똑같이 고르고 진하게 보이나요?")
                                .multilineTextAlignment(.center)
                                .font(.pretendardMedium_20)
                                .padding()
                            
                            Spacer()
                            
                            if !distance.canStart {
                                Text("휴대폰과의 거리를 조정해주세요!")
                                    .font(.pretendardMedium_18)
                                    .foregroundColor(.customRed)
                            }
                            
                            HStack {
                                CustomButton(title: "예",
                                             background: viewModel.userSayYes ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        viewModel.userSayYes.toggle()
                                        testPercent += 0.5
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        viewModel.userAnswer.append("Y")
                                        isChange.toggle()
                                        viewModel.userSayYes.toggle()
                                    }
                                })
                                .frame(maxHeight: 75)
                                .padding(.trailing, -10)
                                .disabled(!distance.canStart)
                                CustomButton(title: "아니오",
                                             background: viewModel.userSayNo ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        viewModel.userSayNo.toggle()
                                        testPercent += 0.5
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        viewModel.userAnswer.append("N")
                                        isChange.toggle()
                                        viewModel.userSayNo.toggle()
                                    }
                                })
                                .frame(maxHeight: 75)
                                .padding(.leading, -10)
                                .disabled(!distance.canStart)
                            }
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
}


//MARK: - 왼쪽 눈 화면
private struct AstigmatismLeft: View {
    @ObservedObject var viewModel: AstigmatismTestViewModel
    @ObservedObject var distance: DistanceConditionViewModel
    @Binding var testPercent: Double
    @Binding var isTestComplete: Bool
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
            //TODO: - 테스트 안내문구 보여주기
            ProgressView(value: testPercent)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))
            
            Spacer()
            
            VStack {
                Text("난시 검사를 시작합니다.")
                    .font(.pretendardMedium_22)
                HStack(spacing: 5) {
                    Text("오른쪽 눈을 감고")
                        .font(.pretendardBold_22)
                    Text("준비되면")
                        .font(.pretendardMedium_22)
                }
                Text("버튼을 눌러주세요!")
                    .font(.pretendardMedium_22)
            }
            
            Spacer()
            
            Image("Component8")
            
            Spacer()
            
            CustomButton(title: "다음",
                         background: .customGreen,
                         fontStyle: .pretendardMedium_18,
                         action: {
                isReady = true
            })
            .frame(maxHeight: 75)
        } else {
            //TODO: - 테스트 화면 보여주기
            VStack {
                NavigationStack {
                    ZStack {
                        DistanceFaceAndDevice(model: distance)
                        BackgroundView()
                        VStack {
                            ProgressView(value: testPercent)
                                .progressViewStyle(LinearProgressViewStyle(tint: .customGreen))
                            HStack(alignment: .lastTextBaseline) {
                                Spacer()
                                Text("현재거리 ")
                                    .font(.pretendardRegular_30)
                                Text("\(distance.distance)")
                                    .font(.pretendardRegular_40)
                                    .foregroundColor(distance.canStart ? .customGreen : .customRed)
                                Text("CM")
                                    .font(.pretendardRegular_30)
                                Spacer()
                            }
                            Spacer()
                            
                            Image("Component5")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Spacer()
                            
                            Text("원의 중심에 초점을 맞추세요.\n모든 선이 똑같이 고르고 진하게 보이나요?")
                                .multilineTextAlignment(.center)
                                .font(.pretendardMedium_20)
                            
                            Spacer()
                            
                            if !distance.canStart {
                                Text("휴대폰과의 거리를 조정해주세요!")
                                    .font(.pretendardMedium_18)
                                    .foregroundColor(.customRed)
                            }
                            
                            HStack {
                                CustomButton(title: "예",
                                             background: viewModel.userSayYes ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        viewModel.userSayYes.toggle()
                                        testPercent += 0.5
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        viewModel.userAnswer.append("Y")
                                        isTestComplete.toggle()
                                        viewModel.userSayYes.toggle()
                                    }
                                })
                                .frame(maxHeight: 75)
                                .padding(.trailing, -10)
                                .disabled(!distance.canStart)
                                CustomButton(title: "아니오",
                                             background: viewModel.userSayNo ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        viewModel.userSayNo.toggle()
                                        testPercent += 0.5
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        viewModel.userAnswer.append("N")
                                        isTestComplete.toggle()
                                        viewModel.userSayYes.toggle()
                                    }
                                })
                                .frame(maxHeight: 75)
                                .padding(.leading, -10)
                                .disabled(!distance.canStart)
                            }
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
}

//MARK: - 테스트 결과 화면
private struct AstigmatismTestResultView: View {
    @ObservedObject var viewModel: AstigmatismTestViewModel
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Text("난시 검사 결과")
                .font(.pretendardBold_32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            
            let total = coordinator.resultInfo.count >= 5 ? 5 : coordinator.resultInfo.count
            
            if total != 0 {
                ScrollView(showsIndicators: false) {
                    ResultTextView(viewModel: viewModel)
                   
                    Text("내 주변에 총 \(total >= 5 ? "5개 이상의" : "\(total)개의") 장소가 있어요!")
                        .font(.pretendardBold_20)
                        
                        .foregroundColor(.customGreen)
                    Color.customGreen
                        .frame(height: 3)
                        .padding(.horizontal, 10)
                    VStack {
                        ForEach(0..<total) { index in
                            PlaceCellView(place: coordinator.resultInfo[index])
                        }
                    }
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(.customGreen)
                        .frame(height: 80)
                        .padding(10)
                        .overlay(
                            Text("모든 장소를 확인하려면 내 주변 화면에서 확인하세요!")
                                .multilineTextAlignment(.center)
                                .font(.pretendardLight_16)
                                .foregroundColor(.tabGray)
                        )
                }
            }
            else {
                ResultTextView(viewModel: viewModel)
                
                Spacer()
                
                Text("내 주변에 안과나 안경점이 없어요!")
                    .font(.pretendardBold_24)
                    .foregroundColor(.customGreen)
                
                Spacer()
                
                Text("내 주변 화면에서\n다른 안과나 안경점을 찾아보세요!")
                    .multilineTextAlignment(.center)
                    .font(.pretendardSemiBold_20)
                    
                Spacer()
            }
            
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            Coordinator.shared.checkIfLocationServiceIsEnabled()
        }
        
        CustomButton(title: "돌아가기",
                     background: .customGreen,
                     fontStyle: .pretendardBold_16,
                     //TODO: - 사용자 모델 추가 시 저장하고 dismiss() 하기!
                     action: { dismiss() } )
        .frame(maxHeight: 75)
        
    }
}

//MARK: - 결과 설명 화면
private struct ResultTextView: View {
    @ObservedObject var viewModel: AstigmatismTestViewModel
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 20) {
                Text("왼쪽")
                    .font(.pretendardBold_32)
                Image(viewModel.leftImage)
            }
            Spacer()
            VStack(spacing: 20) {
                Text("오른쪽")
                    .font(.pretendardBold_32)
                Image(viewModel.rightImage)
            }
            Spacer()
        }
        
        HStack(spacing: 0) {
            Text(viewModel.titleText)
                .font(.pretendardBold_18)
            Text(viewModel.subTitleText)
                .font(.pretendardMedium_18)
        }
        .padding(.vertical, 10)
        
        
        Text(viewModel.explainText)
            .multilineTextAlignment(.center)
            .font(.pretendardMedium_18)
        
        Spacer()
        
        WarningText()
        
        Spacer()
    }
}


#Preview {
    AstigmatismTestView(distance: DistanceConditionViewModel())
}
