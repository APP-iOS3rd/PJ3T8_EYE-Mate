//
//  SightTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct SightTestView: View {
    @StateObject var viewModel = SightTestViewModel()
    
    //MARK: - 테스트용으로 true로 설정, 기본값은 false
    @State var isTestComplete: Bool = false
    
    var body: some View {
        if !isTestComplete {
            SightTest(viewModel: viewModel,
                      isTestComplete: $isTestComplete)
        } else {
            SightTestResultView(viewModel: viewModel)
        }
    }
}

//MARK: - 테스트 화면
private struct SightTest: View {
    @EnvironmentObject var router: Router
    @ObservedObject var viewModel: SightTestViewModel
    @Binding var isTestComplete: Bool
    @State var testPercent = 0.0
    @State var isChange: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 5)
            
            HStack {
                Text("시야 검사")
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
            ProgressView(value: testPercent)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))
            if !isChange {
                SightRight(viewModel: viewModel,
                           testPercent: $testPercent,
                           isChange: $isChange)
            } else {
                SightLeft(viewModel: viewModel,
                          testPercent: $testPercent,
                          isTestComplete: $isTestComplete)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - 오른쪽 눈 화면
private struct SightRight: View {
    @ObservedObject var viewModel: SightTestViewModel
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @Binding var testPercent: Double
    @Binding var isChange: Bool
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
            Spacer()
            
            VStack {
                Text("시야 검사를 시작합니다.")
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
            VStack {
                VStack {
                    ZStack {
                        DistanceFaceAndDevice(model: distance)
                        BackgroundView()
                        VStack {
                            HStack(alignment: .lastTextBaseline) {
                                Spacer()
                                Text("현재거리 ")
                                    .font(.pretendardRegular_30)
                                Text("\(distance.distance)")
                                    .font(.pretendardRegular_40)
                                    .foregroundColor(distance.canSightStart ? .customGreen : .customRed)
                                Text("CM")
                                    .font(.pretendardRegular_30)
                                Spacer()
                            }
                            Spacer()
                            
                            Image("Component6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Spacer()
                            
                            Text("중앙 검은색 점에 초점을 맞추세요.\n모든 선과 사각형이 균일하고, 규칙적으로 보이나요?")
                                .multilineTextAlignment(.center)
                                .font(.pretendardMedium_20)
                            
                            Spacer()
                            
                            Text("휴대폰과의 거리를 조정해주세요!")
                                .font(.pretendardMedium_18)
                                .foregroundColor(.customRed)
                                .opacity(!distance.canSightStart ? 1.0 : 0.0)
                            
                            HStack {
                                CustomButton(title: "예",
                                             background: distance.canSightStart ? .customGreen : .buttonGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        testPercent += 0.5
                                    }
                                    viewModel.userAnswer.append("Y")
                                    isChange.toggle()
                                })
                                .frame(maxHeight: 75)
                                .padding(.trailing, -10)
                                .disabled(!distance.canSightStart)
                                CustomButton(title: "아니오",
                                             background: distance.canSightStart ? .customGreen : .buttonGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        testPercent += 0.5
                                    }
                                    viewModel.userAnswer.append("N")
                                    isChange.toggle()
                                })
                                .frame(maxHeight: 75)
                                .padding(.leading, -10)
                                .disabled(!distance.canSightStart)
                            }
                        }
                    }
                }
            }
        }
    }
}


//MARK: - 왼쪽 눈 화면
private struct SightLeft: View {
    @ObservedObject var viewModel: SightTestViewModel
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @Binding var testPercent: Double
    @Binding var isTestComplete: Bool
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
            //TODO: - 테스트 안내문구 보여주기
            Spacer()
            
            VStack {
                Text("시야 검사를 시작합니다.")
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
                VStack {
                    ZStack {
                        DistanceFaceAndDevice(model: distance)
                        BackgroundView()
                        VStack {
                            HStack(alignment: .lastTextBaseline) {
                                Spacer()
                                Text("현재거리 ")
                                    .font(.pretendardRegular_30)
                                Text("\(distance.distance)")
                                    .font(.pretendardRegular_40)
                                    .foregroundColor(distance.canSightStart ? .customGreen : .customRed)
                                Text("CM")
                                    .font(.pretendardRegular_30)
                                Spacer()
                            }
                            Spacer()
                            
                            Image("Component6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Spacer()
                            
                            Text("중앙 검은색 점에 초점을 맞추세요.\n모든 선과 사각형이 균일하고, 규칙적으로 보이나요?")
                                .multilineTextAlignment(.center)
                                .font(.pretendardMedium_20)
                            
                            Spacer()
                            
                            Text("휴대폰과의 거리를 조정해주세요!")
                                .font(.pretendardMedium_18)
                                .foregroundColor(.customRed)
                                .opacity(!distance.canSightStart ? 1.0 : 0.0)
                            
                            
                            HStack {
                                CustomButton(title: "예",
                                             background: distance.canSightStart ? .customGreen : .buttonGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        testPercent += 0.5
                                    }
                                    viewModel.userAnswer.append("Y")
                                    isTestComplete.toggle()
                                })
                                .frame(maxHeight: 75)
                                .padding(.trailing, -10)
                                .disabled(!distance.canSightStart)
                                CustomButton(title: "아니오",
                                             background: distance.canSightStart ? .customGreen : .buttonGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    withAnimation {
                                        testPercent += 0.5
                                    }
                                    viewModel.userAnswer.append("N")
                                    isTestComplete.toggle()
                                })
                                .frame(maxHeight: 75)
                                .padding(.leading, -10)
                                .disabled(!distance.canSightStart)
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: - 테스트 결과 화면
private struct SightTestResultView: View {
    @ObservedObject var viewModel: SightTestViewModel
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared
    @ObservedObject var loginViewModel = LoginViewModel.shared
    @EnvironmentObject var router: Router
    @EnvironmentObject var tabManager: TabManager
    
    @AppStorage("Login") var loggedIn: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 1)
                
                TestResultTitleView(type: .eyesight)
                
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
                            ForEach(0..<total, id: \.self) { index in
                                PlaceCellView(place: coordinator.resultInfo[index])
                            }
                            
                            Button(action: {
                                //TODO: - 로그인 상태라면 저장 후 이동, 아니면 Alert창
                                if loggedIn {
                                    viewModel.saveResult(userUID)
                                    tabManager.selection = .eyeMap
                                    router.navigateBack()
                                } else {
                                    showAlert = true
                                }
                            }, label: {
                                RoundedRectangle(cornerRadius: 10)
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
                            })
                        }
                    }
                }
                else {
                    ResultTextView(viewModel: viewModel)
                    
                    Spacer()
                    
                    Text("내 주변에 안과나 안경점이 없어요..")
                        .font(.pretendardBold_24)
                        .foregroundColor(.customGreen)
                    
                    Spacer()
                    
                    Text("내 주변 화면에서\n다른 안과나 안경점을 찾아보세요!")
                        .multilineTextAlignment(.center)
                        .font(.pretendardSemiBold_20)
                    
                    Spacer()
                }
                
                CustomButton(title: "돌아가기",
                             background: .customGreen,
                             fontStyle: .pretendardBold_16,
                             action: {
                    if loggedIn {
                        //TODO: - 사용자 모델 추가 시 저장하고 navigateBack() 하기!
                        viewModel.saveResult(userUID)
                        router.navigateToRoot()
                    } else {
                        //TODO: - Alert 창 띄워주고 선택
                        showAlert = true
                    }
                } )
                .frame(maxHeight: 75)
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                MapCoordinator.shared.checkIfLocationServiceIsEnabled()
            }
            TestAlertView(showAlert: $showAlert)
        }
        .fullScreenCover(isPresented: $loginViewModel.showFullScreenCover, content: {
            LoginView(isAlertView: true)
        })
        .animation(.easeInOut(duration: 0.1), value: showAlert)
    }
}

//MARK: - 결과 설명 화면
private struct ResultTextView: View {
    @ObservedObject var viewModel: SightTestViewModel
    
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
    SightTestView()
}
