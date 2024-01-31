//
//  AstigmatismDataView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/31/24.
//

import SwiftUI

struct AstigmatismData: Identifiable {
    let id = UUID()
    let date: String
    let left: String
    let right: String
}

struct AstigmatismDataView: View {
    let dataArray: [AstigmatismData] = []

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
                            .frame(width: 120, alignment: .leading)
                        Spacer()
                        HStack(spacing: 32) {
                            HStack{
                                Text("좌")
                                    .font(.pretendardBold_18)
                                Spacer()
                                ColoredText(receivedText: "\(data.left)")
                            }.frame(width: 80)
                            HStack{
                                Text("우")
                                    .font(.pretendardBold_18)
                                Spacer()
                                ColoredText(receivedText: "\(data.right)")
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
    AstigmatismDataView()
}
