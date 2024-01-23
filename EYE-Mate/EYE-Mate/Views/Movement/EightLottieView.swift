//
//  EightLottieView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/23/24.
//

import SwiftUI
import UIKit

struct EightLottieView: View {
    var body: some View {
           VStack {
               Text("8자 운동")
                   .font(.pretendardSemiBold_20)
           }.onAppear{
               guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
               windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
           }.onDisappear{
               guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
               windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
           }
       }
}

#Preview {
    EightLottieView()
}
