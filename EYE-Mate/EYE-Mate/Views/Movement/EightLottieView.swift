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
    @State private var movementPercent = 0.0

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ProgressView(value: movementPercent, total: 100)
                .padding(.top, 8)
                .progressViewStyle(LinearProgressViewStyle(tint: Color.customGreen))
                .onReceive(timer) { _ in
                    if movementPercent < 100 {
                        movementPercent += 0.5
                    }}
            ZStack {
                HStack {
                    Spacer()
                    Text("노란색 점을 따라 눈을 움직여보세요")
                        .font(.custom("Pretendard-Bold", size: 30))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .padding(8)
                    }
                }
            }
            LottieView(animation: .named("eight_movement"))
                .looping()
        }.onAppear{
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
        }.onDisappear{
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }.navigationBarBackButtonHidden(true)

            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(.black)
    }
}

#Preview {
    EightLottieView()
}
