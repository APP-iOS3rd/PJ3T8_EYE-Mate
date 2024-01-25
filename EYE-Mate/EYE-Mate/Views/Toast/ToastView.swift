//
//  ToastView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/25/24.
//

import SwiftUI

struct ToastView: View {
    var onCancelTapped: (() -> Void)

    var body: some View {
        Button {
            onCancelTapped()
        } label : {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 0) {
                    Text("눈 운동")
                        .font(.pretendardSemiBold_20)
                        .foregroundColor(.black)
                        .padding(0)
                    Text("을 완료했어요 👀")
                        .font(.pretendardSemiBold_20)
                        .foregroundColor(.white)
                        .padding(0)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.customGreen.opacity(0.9))
            .cornerRadius(48)
            .frame(minWidth: 0, maxWidth: .infinity)
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        }
    }
}

#Preview {
    ToastView() {
        print("push")
    }
}
