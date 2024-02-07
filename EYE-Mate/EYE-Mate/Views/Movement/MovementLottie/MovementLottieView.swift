//
//  MovementLottieView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/23/24.
//

import SwiftUI
import UIKit
import Lottie

struct MovementLottieView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var showToast: Bool
    @Binding var movementType: String

    @State private var movementPercent = 0.0
    @State private var isEyeExerciseComplete = false
    @State private var isStart = false


    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var fileName: String {
        switch movementType {
        case "Line":
            "line-movement"
        case "Circle":
            "circle-movement"
        case "Eight":
            "eight-movement"
        default:
            "line-movement"
        }
    }

    private func goBack() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dismiss()
        }
    }

    var body: some View {
        if isStart {
        VStack {
            ProgressView(value: movementPercent, total: 100)
                .padding(.top, 16)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))
                .onReceive(timer) { _ in
                    if movementPercent < 100 {
                        movementPercent += 0.5
                    } else {
                        isEyeExerciseComplete = true
                    }}
            ZStack {
                HStack {
                    Spacer()
                    if isEyeExerciseComplete {
                        Text("눈 운동 완료!")
                            .font(.pretendardBold_30)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("초록색 점을 따라 눈을 움직여보세요")
                            .font(.pretendardBold_30)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                if !isEyeExerciseComplete {
                    HStack {
                        Spacer()
                        Button(action: {
                            goBack()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .padding(8)
                        }
                    }
                }
            }
            if isEyeExerciseComplete {
                Spacer()
                CustomButton(title: "완료", background: Color.customGreen, fontStyle: .pretendardSemiBold_22, action: {
                    showToast.toggle()
                    goBack()
                }).frame(height: 88)
            } else {
                Spacer()
                LottieView(animation: .named(fileName))
                    .configure({ lottieView in
                        lottieView.contentMode = .scaleAspectFit
                    })
                    .looping()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(.black)
        } else {
            VStack {
                Text("시작하기 버튼을 눌러 눈 운동을 시작해보세요")
                    .font(.pretendardBold_30)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 100)
                Spacer()
                CustomButton(title: "시작하기", background: Color.customGreen, fontStyle: .pretendardSemiBold_22, action: {
                    isStart.toggle()
                }).frame(height: 88)
            }     .navigationBarBackButtonHidden(true)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                .background(.black)
        }


    }
}

#Preview {
    @State var showToast: Bool = false
    @State var movementType: String = "Line"

    return MovementLottieView(showToast: $showToast, movementType: $movementType)
}
