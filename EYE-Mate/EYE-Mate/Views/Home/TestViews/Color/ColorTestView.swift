//
//  ColorTestView.swift
//  EYE-Mate
//
//  Created by 이성현 on 2024/01/31.
//

import SwiftUI

struct ColorTestView: View {
    @StateObject var viewModel = ColorTestViewModel()
    @State var isTestComplete = false
    
    
    var body: some View {
        if !isTestComplete {
            ColorTest(viewModel: viewModel, isTestComplete: $isTestComplete)
        } else {
            ColorTestResultView(viewModel: viewModel)
        }
    }
}

//MARK: - 테스트 화면
private struct ColorTest: View {
    @ObservedObject var viewModel: ColorTestViewModel
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var answer = ""
    @State private var testPercent = 0.0
    @Binding var isTestComplete: Bool
    
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack {
                if !viewModel.isTestStarted {
                    Spacer()
                    
                    Text("보이는 각 판의 번호를 입력하세요.\n다음 화면부터 테스트가 시작됩니다!")
                        .multilineTextAlignment(.center)
                        .font(.pretendardMedium_20)
                } else {
                    ProgressView(value: testPercent, total: 12)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))
                    
                    Spacer()
                    
                    Text("보이는 각 판의 번호를 입력하세요.")
                        .multilineTextAlignment(.center)
                        .font(.pretendardMedium_20)
                }
                
                Spacer()
                
                viewModel.testColorSet[viewModel.index]
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                if viewModel.isTestStarted {
                    Text("아무것도 보이지 않으면 다음버튼을 클릭하세요.")
                        .font(.pretendardMedium_18)
                }
                TextField("숫자를 입력하세요.", text: $answer)
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
                HStack {
                    if viewModel.index >= 2 {
                        CustomButton(title: "뒤로",
                                     background: .customGreen,
                                     fontStyle: .pretendardBold_16,
                                     action: {
                            viewModel.userAnswer[viewModel.index] = answer
                            withAnimation {
                                testPercent -= 1
                            }
                            viewModel.index -= 1
                            answer = viewModel.userAnswer[viewModel.index]
                        }
                        )
                        .frame(maxHeight: 75)
                    }
                    
                    CustomButton(title: viewModel.index != 12 ? "다음" : "제출하기",
                                 background: .customGreen,
                                 fontStyle: .pretendardBold_16,
                                 action: {
                        viewModel.userAnswer[viewModel.index] = answer
                        isFocused = false
                        viewModel.isTestStarted = true
                        withAnimation {
                            testPercent += 1
                        }
                        
                        viewModel.index += 1
                        if viewModel.index >= viewModel.testColorSet.count {
                            viewModel.index = 0
                            viewModel.updateResult()
                            isTestComplete.toggle()
                        }
                        answer = viewModel.userAnswer[viewModel.index]
                    }
                    )
                    .frame(maxHeight: 75)
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("색채 검사")
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
        .onTapGesture {
            isFocused = false
        }
    }
}

//MARK: - 테스트 결과 화면
private struct ColorTestResultView: View {
    @ObservedObject var viewModel: ColorTestViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Text("색채 검사 결과")
                .font(.pretendardBold_32)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
            ColorTestResultTextView(viewModel: viewModel)
            
            Spacer()
            
            ColorTestResultGraph(viewModel: viewModel)
            
            CustomButton(isLabel: true,
                         background: .customGreen,
                         fontStyle: .pretendardMedium_20,
                         action: {
                //TODO: - 내주변 탭으로 이동하기
            } )
            .frame(maxWidth: 350, maxHeight: 70)
            
            Spacer()
            
            WaringText()
            
            Spacer()
            
            CustomButton(title: "돌아가기",
                         background: .customGreen,
                         fontStyle: .pretendardBold_16,
                         //TODO: - 사용자 모델 추가 시 저장하고 dismiss() 하기!
                         action: { dismiss() } )
            .frame(maxHeight: 75)
        }
        .navigationBarBackButtonHidden()
    }
}

//MARK: - 테스트 결과 텍스트
private struct ColorTestResultTextView: View {
    @ObservedObject var viewModel: ColorTestViewModel
    
    //TODO: - 사용자 계정 나오면 ViewModel에 추가 후 수정필요!
    var body: some View {
        VStack(alignment: .leading) {
            Text("어디로 가야 하오 님은")
                .font(.pretendardRegular_22)
            HStack(alignment: .lastTextBaseline) {
                Text(viewModel.resultMessage)
                    .font(.pretendardSemiBold_32)
                Text("입니다.")
                    .font(.pretendardRegular_22)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 30)
    }
}

//MARK: - 테스트 결과 표
private struct ColorTestResultGraph: View {
    @ObservedObject var viewModel: ColorTestViewModel
    
    var body: some View {
        Spacer()
        Text(viewModel.result)
            .font(.pretendardMedium_22)
        GeometryReader { g in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("순서")
                        .font(.pretendardRegular_26)
                    Spacer()
                    Text("정답")
                        .font(.pretendardRegular_26)
                    Spacer()
                    Text("제출")
                        .font(.pretendardRegular_26)
                    Spacer()
                } // HStack
                Color.customGreen
                    .frame(width: g.size.width / 1.2, height: 2)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(1..<13) { index in
                            HStack(alignment: .center) {
                                Spacer()
                                Text("\(index).")
                                    .frame(minWidth: 35)
                                    .font(.pretendardRegular_18)
                                
                                Spacer()
                                Text(viewModel.answerSet[index])
                                    .frame(minWidth: 35)
                                    .font(.pretendardRegular_18)
                                
                                Spacer()
                                Text(viewModel.userAnswer[index])
                                    .frame(minWidth: 35)
                                    .font(.pretendardRegular_18)
                                
                                Spacer()
                            }
                            .frame(maxHeight: 15)
                            if index <= 11 {
                                Color.customGreen
                                    .frame(width: g.size.width / 1.5, height: 1)
                            }
                        }
                        
                    }
                }
                Spacer()
            } // VStack
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.customGreen, lineWidth: 2)
                    .foregroundColor(.white)
                    .shadow(radius: 2, x: 1, y: 1)
                    .frame(width: g.size.width / 1.2)
            )
            .padding()
        }
    }
}

#Preview {
    ColorTestView()
}
