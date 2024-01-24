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

    var body: some View {
        VStack {
            ZStack {
            HStack {
                Spacer()
                Text("편안하게 정면을 응시해주세요")
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
