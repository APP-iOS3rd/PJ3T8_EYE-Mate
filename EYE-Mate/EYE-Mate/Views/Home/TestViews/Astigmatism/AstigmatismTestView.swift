//
//  AstigmatismTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct AstigmatismTestView: View {
    @StateObject var viewModel = AstigmatismTestViewModel()
    //MARK: - 테스트용으로 true로 설정, 기본값은 false
    @State var isTestComplete: Bool = false
    
    var body: some View {
        if !isTestComplete {
            AstigmatismTest(viewModel: viewModel,
                            isTestComplete: $isTestComplete)
        } else {
            AstigmatismTestResultView(viewModel: viewModel)
        }
    }
}

//MARK: - 테스트 화면
private struct AstigmatismTest: View {
    @ObservedObject var viewModel: AstigmatismTestViewModel
    @Binding var isTestComplete: Bool
    @State var testPercent = 0.0
    @State var isChange: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
            VStack {
                Spacer()
                    .frame(height: 5)
                
                HStack {
                    Text("난시 검사")
                        .frame(maxWidth: .infinity)
                        .font(.pretendardBold_24)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image("close")
                            })
                            .padding(.trailing)
                        }
                }
                
                ProgressView(value: testPercent)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))
                
                if !isChange {
                    AstigmatismRight(viewModel: viewModel,
                                     testPercent: $testPercent,
                                     isChange: $isChange)
                } else {
                    AstigmatismLeft(viewModel: viewModel,
                                    testPercent: $testPercent,
                                    isTestComplete: $isTestComplete)
                }
            }
            .navigationBarBackButtonHidden()
        }
}

//MARK: - 오른쪽 눈 화면
private struct AstigmatismRight: View {
    @ObservedObject var viewModel: AstigmatismTestViewModel
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @Binding var testPercent: Double
    @Binding var isChange: Bool
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
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
            VStack {
                NavigationStack {
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
                            
                            Image("Component5")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("원의 중심에 초점을 맞추세요.\n모든 선이 똑같이 고르고 진하게 보이나요?")
                                .multilineTextAlignment(.center)
                                .font(.pretendardMedium_20)
                                .padding()
                            
                            Spacer()
                            
                            Text("휴대폰과의 거리를 조정해주세요!")
                                .font(.pretendardMedium_18)
                                .foregroundColor(.customRed)
                                .opacity(!distance.canStart ? 1.0 : 0.0)
                            
                            HStack {
                                CustomButton(title: "예",
                                             background: distance.canStart ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    viewModel.userAnswer.append("Y")
                                    withAnimation {
                                        testPercent += 0.5
                                    }
                                    isChange.toggle()
                                    //TODO: - 진동주는 이펙트
                                })
                                .frame(maxHeight: 75)
                                .padding(.trailing, -10)
                                .disabled(!distance.canStart)
                                CustomButton(title: "아니오",
                                             background: distance.canStart ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    viewModel.userAnswer.append("N")
                                    withAnimation {
                                        testPercent += 0.5
                                    }
                                    isChange.toggle()
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
    @ObservedObject var distance = DistanceConditionViewModel.shared
    @Binding var testPercent: Double
    @Binding var isTestComplete: Bool
    @State var isReady: Bool = false
    
    var body: some View {
        if !isReady {
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
            VStack {
                NavigationStack {
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
                            
                            Image("Component5")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 10)
                            
                            Spacer()
                            
                            Text("원의 중심에 초점을 맞추세요.\n모든 선이 똑같이 고르고 진하게 보이나요?")
                                .multilineTextAlignment(.center)
                                .font(.pretendardMedium_20)
                            
                            Spacer()
                            
                            Text("휴대폰과의 거리를 조정해주세요!")
                                .font(.pretendardMedium_18)
                                .foregroundColor(.customRed)
                                .opacity(!distance.canStart ? 1.0 : 0.0)
                            
                            
                            HStack {
                                CustomButton(title: "예",
                                             background: distance.canStart ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    viewModel.userAnswer.append("Y")
                                    withAnimation {
                                        testPercent += 0.5
                                        isTestComplete.toggle()
                                    }
                                })
                                .frame(maxHeight: 75)
                                .padding(.trailing, -10)
                                .disabled(!distance.canStart)
                                CustomButton(title: "아니오",
                                             background: distance.canStart ? .customGreen : .btnGray,
                                             fontStyle: .pretendardMedium_18,
                                             action: {
                                    viewModel.userAnswer.append("N")
                                    withAnimation {
                                        testPercent += 0.5
                                    }
                                    isTestComplete.toggle()
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
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared
    @ObservedObject var loginViewModel = LoginViewModel.shared
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tabManager: TabManager
    
    @AppStorage("Login") var loggedIn: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    
    @State var showAlert = false
    
    var body: some View {
        ZStack {
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
                            ForEach(0..<total, id: \.self) { index in
                                PlaceCellView(place: coordinator.resultInfo[index])
                            }
                            
                            Button(action: {
                                //TODO: - 로그인 상태라면 저장 후 이동, 아니면 Alert창
                                if loggedIn {
                                    viewModel.saveResult(userUID)
                                    tabManager.selection = .eyeMap
                                    dismiss()
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
                        //TODO: - 사용자 모델 추가 시 저장하고 dismiss() 하기!
                        viewModel.saveResult(userUID)
                        dismiss()
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
    AstigmatismTestView()
}
