//
//  EightLottieView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/23/24.
//

import SwiftUI
import UIKit
import Lottie

struct EightLottieView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var showToast: Bool
    @Binding var movementType: String

    @State private var movementPercent = 0.0
    @State private var isEyeExerciseComplete = false


    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let customGreenValueProvider = ColorValueProvider(LottieColor(r: 255.0 / 255.0, g: 202.0 / 255.0, b: 166.0 / 255.0, a: 1))
    var keypath: AnimationKeypath {
        switch movementType {
        case "Line":
            AnimationKeypath("Shape Layer 1.Ellipse 1.Fill 1.Color")
        case "Circle":
            AnimationKeypath("Ellipse.Ellipse 1.Fill 1.Color")
        case "Eight":
            AnimationKeypath("ball Outlines.Group 1.Fill 1.Color")
        default:
            AnimationKeypath("")
        }
    }
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
                CustomBtn(title: "완료", background: Color.customGreen, fontStyle: .pretendardSemiBold_22, action: {
                    showToast.toggle()
                    goBack()
                }).frame(height: 88)
            } else {
                Spacer()
                LottieView(animation: .named(fileName))
                    .configure({ lottieView in
                        lottieView.contentMode = fileName == "circle-movement" ? .scaleAspectFit : .scaleAspectFill
                        lottieView.setValueProvider(customGreenValueProvider, keypath: keypath)
                    })
                    .looping()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(.black)
    }
}

//#Preview {
//    StatefulPreviewWrapper(false) { EightLottieView(showToast: $0)}
//}
