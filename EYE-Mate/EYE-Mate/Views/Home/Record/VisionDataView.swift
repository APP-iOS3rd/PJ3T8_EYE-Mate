//
//  VisionDataView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/31/24.
//

import SwiftUI

struct VisionData: Identifiable {
    let id = UUID()
    let date: String
    let left: Double
    let right: Double
}

struct VisionDataView: View {
    let dataArray = [
        VisionData(date: "23.12.30(토)", left: 0.3, right: 0.9),
        VisionData(date: "23.11.21(월)", left: 0.7, right: 1.0),
        VisionData(date: "23.08.15(수)", left: 0.9, right: 1.2),
        VisionData(date: "23.02.04(수)", left: 1.2, right: 1.1),
        VisionData(date: "22.12.20(금)", left: 1.4, right: 1.2)
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
                        HStack(spacing: 32) {
                            HStack{
                                Text("좌")
                                    .font(.pretendardBold_18)
                                Spacer().frame(width: 12)
                                ColoredText(receivedText: "\(data.left)", font: .pretendardBold_28)
                                    .monospaced()
                            }.frame(width: 80)
                            HStack{
                                Text("우")
                                    .font(.pretendardBold_18)
                                Spacer().frame(width: 12)
                                ColoredText(receivedText: "\(data.right)", font: .pretendardBold_28)
                                    .monospaced()
                            }.frame(width: 80)
                        }
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
    VisionDataView()
}
