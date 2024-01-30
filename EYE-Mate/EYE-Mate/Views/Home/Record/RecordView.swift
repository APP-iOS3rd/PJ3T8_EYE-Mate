//
//  Record.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/22.
//

import SwiftUI

struct RecordView: View {
    @Environment(\.dismiss) var dismiss

    private func goBack() {
        dismiss()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 12){
                    Text("EYE-Mate")
                        .font(.pretendardSemiBold_22)
                    HStack {
                        Button {
                            goBack()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                        Text("기록")
                            .font(.pretendardSemiBold_32)
                    }
                }
                Spacer()
                Circle()
                    .foregroundColor(Color.blue)
                    .frame(width: 50, height: 50)
            }
            .frame(height: 112)
            .padding(.horizontal, 24)
            HorizontalDivider(color: Color.customGreen, height: 4)
        }
        Spacer()
    }
}

#Preview {
    RecordView()
}
