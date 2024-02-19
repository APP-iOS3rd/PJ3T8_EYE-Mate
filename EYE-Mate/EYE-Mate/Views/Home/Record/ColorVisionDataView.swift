//
//  ColorVisionDataView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/31/24.
//

import SwiftUI

struct ColorVisionData: Identifiable {
    let id = UUID()
    let date: String
    let status: String
}

struct ColorVisionDataView: View {
    let dataArray = [
        ColorVisionData(date: "23.12.30(토)", status: "좋음"),
        ColorVisionData(date: "23.11.21(월)", status: "나쁨"),
        ColorVisionData(date: "23.08.15(수)", status: "양호"),
    ]

    var body: some View {
        if dataArray.isEmpty {
            Text("검사 이력이 없습니다")
                .font(.pretendardBold_20)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            ForEach(dataArray, id: \.id) { data in
                VStack(spacing: 0) {
                    HStack {
                        Text("\(data.date)")
                            .font(.pretendardRegular_18)
                            .frame(width: 128, alignment: .leading)
                            .monospaced()
                        Spacer()
                        ColoredText(receivedText: "\(data.status)", font: .pretendardBold_28)
                        Spacer()
                    }.frame(height: 52)

                    if data.id != dataArray.last?.id {
                        HorizontalDivider(color: Color.lightGray, height: 1)
                    }
                }
            }
        }
    }
}

#Preview {
    ColorVisionDataView()
}
