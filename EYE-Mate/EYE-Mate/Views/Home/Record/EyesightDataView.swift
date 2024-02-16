//
//  EyesightDataView.swift
//  EYE-Mate
//
//  Created by seongjun on 1/31/24.
//

import SwiftUI

struct EyesightData: Identifiable {
    let id = UUID()
    let date: String
    let left: String
    let right: String
}

struct EyesightDataView: View {
    let dataArray: [EyesightData] = [
        EyesightData(date: "23.12.30(토)", left: "좋음", right: "좋음"),
        EyesightData(date: "23.11.21(월)", left: "좋음", right: "양호"),
        EyesightData(date: "23.08.15(수)", left: "양호", right: "나쁨"),
        EyesightData(date: "23.02.04(수)", left: "나쁨", right: "나쁨")]
    
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
                                ColoredText(receivedText: "\(data.left)", font: .pretendardBold_28)
                            }.frame(width: 80)
                            HStack{
                                Text("우")
                                    .font(.pretendardBold_18)
                                Spacer()
                                ColoredText(receivedText: "\(data.right)", font: .pretendardBold_28)
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
    EyesightDataView()
}
