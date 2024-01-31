//
//  RecordBox.swift
//  EYE-Mate
//
//  Created by seongjun on 1/30/24.
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
        ForEach(dataArray, id: \.id) { data in
            HStack {
                Text("\(data.date)")
                    .font(.pretendardRegular_18)
                    .padding()
                Spacer()
                Text("좌")
                    .font(.pretendardRegular_18)
                    .padding()


            }
        }
    }
}

struct RecordBox: View {
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text("시력")
                        .font(.pretendardBold_20)
                    Spacer()
                    Button {

                    } label: {
                        Text("모두보기")
                            .font(.pretendardRegular_14)
                            .foregroundStyle(.black)
                    }
                }
                HorizontalDivider(color: Color.lightGray, height: 3)
                VStack(alignment: .leading, spacing: 0) {
                    //                    Text("검사 이력이 없습니다")
                    //                        .font(.pretendardBold_20)
                    //                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    VisionDataView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.25), radius: 4, x: 2, y: 2)
        }
    }
}

#Preview {
    RecordBox()
}
