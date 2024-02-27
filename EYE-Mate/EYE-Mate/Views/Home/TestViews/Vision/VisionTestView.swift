//
//  VisionTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct VisionTestView: View {
    @ObservedObject var viewModel = VisionTestViewModel.shared
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @State var isTestComplete = false
    
    var body: some View {
        if !isTestComplete {
            VisionTest(isTestComplete: $isTestComplete)
        } else {
            VisionTestResultView()
        }
    }
}

//MARK: - 테스트 화면
private struct VisionTest: View {
    @EnvironmentObject var router: Router
    
    @ObservedObject var viewModel = VisionTestViewModel.shared
    
    @Binding var isTestComplete: Bool
    
    @State var isChange: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 5)
            
            HStack {
                Text("시력 검사")
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
            if !isChange {
                //TODO: - 오른쪽 눈 시야 검사
                VisionRight(isChange: $isChange)
                    .onAppear(perform: {
                        viewModel.change()
                    })
            } else {
                //TODO: - 왼쪽 눈 시야검사
                VisionLeft(isTestComplete: $isTestComplete)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - 오른쪽 눈 화면
private struct VisionRight: View {
    @ObservedObject var viewModel = VisionTestViewModel.shared
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @Binding var isChange: Bool
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
            //TODO: - 테스트 안내문구 보여주기
            Spacer()
            
            VStack {
                Text("시력 측정을 시작합니다.")
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
                                    .foregroundColor(distance.canStart ? .customGreen : .customRed)
                                Text("CM")
                                    .font(.pretendardRegular_30)
                                Spacer()
                            }
                            Spacer()
                            
                            //TODO: - 시력검사 화면 보여주기
                            TestView(changeValue: $isChange, type: BothEyes.right,
                                     isAnimation: distance.canStart)
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
}


//MARK: - 왼쪽 눈 화면
private struct VisionLeft: View {
    @ObservedObject var viewModel = VisionTestViewModel.shared
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @Binding var isTestComplete: Bool
    
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
            Spacer()
            
            VStack {
                Text("시력 측정을 시작합니다.")
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
                                    .foregroundColor(distance.canStart ? .customGreen : .customRed)
                                Text("CM")
                                    .font(.pretendardRegular_30)
                                Spacer()
                            }
                            Spacer()
                            
                            //TODO: - 시력검사 화면 보여주기
                            TestView(changeValue: $isTestComplete, type: BothEyes.left, isAnimation: distance.canStart)
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
}

//MARK: - 테스트 화면
private struct TestView: View {
    @ObservedObject var viewModel = VisionTestViewModel.shared
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @State private var selectedButtonIndex: Int?
    @Binding var changeValue: Bool
    @State private var confused = false
    @State var type: BothEyes
    
    @State var isAnimation: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Text("휴대폰과의 거리를 조정해주세요!")
                    .font(.pretendardRegular_20)
                    .foregroundColor(.customRed)
                    .opacity(!isAnimation ? 1.0 : 0.0)
                    .offset(y: -UIScreen.main.bounds.height * 0.15)
                
                Text(viewModel.answer)
                    .font(.system(size: CGFloat(viewModel.fontSize)))
                    .blur(radius: isAnimation ? 0 : 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customGreen, lineWidth: 3)
                    .foregroundColor(.white)
                    .shadow(radius: 3, x: 1, y: 1)
            )
            .padding(30)
            .onChange(of: distance.canStart) { newValue in
                withAnimation {
                    isAnimation = newValue
                }
            }
            
            
            Text("위의 문양을 보고 같은 문양을 고르세요.")
                .font(.pretendardRegular_20)
            
            HStack(spacing: 20) {
                ForEach(0..<3){ index in
                    Button(action: {
                        withAnimation {
                            if index == selectedButtonIndex {
                                selectedButtonIndex = nil
                                viewModel.nextButton = false
                            } else {
                                confused = false
                                selectedButtonIndex = index
                                viewModel.userAnswer = viewModel.question[selectedButtonIndex ?? 0]
                                viewModel.nextButton = true
                            }
                        }
                    }, label: {
                        Text(viewModel.question[index])
                            .font(.pretendardMedium_22)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    })
                    .padding(25)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 5)
                            .background(selectedButtonIndex == index ? Color.customGreen : .white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    )
                }
                Button(action: {
                    withAnimation {
                        confused.toggle()
                        selectedButtonIndex = nil
                        viewModel.nextButton = true
                    }
                    viewModel.userAnswer = "?"
                }, label: {
                    Text("?")
                        .font(.pretendardMedium_22)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                })
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 5)
                        .background(confused ? Color.customGreen : .white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
            }
            CustomButton(title: "다음",
                         background: distance.canStart && viewModel.nextButton ? .customGreen : .buttonGray,
                         fontStyle: .pretendardMedium_18,
                         action: {
                viewModel.checkAnswer($changeValue, type)
                selectedButtonIndex = nil
                confused = false
                viewModel.nextButton = false
            })
            .frame(maxHeight: 75)
            .disabled(!distance.canStart || !viewModel.nextButton)
        }
    }
}

//MARK: - 테스트 결과 화면
private struct VisionTestResultView: View {
    @ObservedObject var viewModel = VisionTestViewModel.shared
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared
    @ObservedObject var loginViewModel = LoginViewModel.shared
    
    @EnvironmentObject var router: Router
    @EnvironmentObject var tabManager: TabManager
    
    @AppStorage("Login") var loggedIn: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    
    @State var showAlert: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 1)
                
                TestResultTitleView(type: .vision)
                
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
                    
                    Text("내 주변에 안과나 안경점이 없어요!")
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
    @ObservedObject var viewModel: VisionTestViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .lastTextBaseline) {
                Text("측정거리: ")
                    .font(.pretendardLight_26)
                
                HStack(alignment: .lastTextBaseline) {
                    Text("\(viewModel.userDistance)")
                        .font(.pretendardMedium_36)
                    Text("CM")
                        .font(.pretendardLight_26)
                }
                .background(
                    Color.customGreen
                        .frame(height: 4)
                        .offset(y: 20)
                )
            }
            .padding([.horizontal, .bottom], 15)
            
            
            HStack {
                Spacer()
                Color.customGreen
                    .frame(width: 3, height: 20)
                HStack(spacing: 20) {
                    Text("좌")
                        .font(.pretendardSemiBold_20)
                    Text("\(viewModel.leftVision)")
                        .font(.pretendardBold_32)
                        .foregroundColor(viewModel.fontColor(viewModel.leftVision))
                }
                Spacer()
                Color.customGreen
                    .frame(width: 3, height: 20)
                HStack(spacing: 20) {
                    Text("우")
                        .font(.pretendardSemiBold_20)
                    Text("\(viewModel.rightVision)")
                        .font(.pretendardBold_32)
                        .foregroundColor(viewModel.fontColor(viewModel.rightVision))
                }
                Spacer()
            }
            .padding(.bottom, 5)
            
            Text(viewModel.explainText)
                .font(.pretendardLight_16)
                .padding(10)
            
            WarningText()
            
            Spacer()
        }
        .padding(.leading, 10)
    }
}


#Preview {
    VisionTestView(viewModel: VisionTestViewModel())
}
