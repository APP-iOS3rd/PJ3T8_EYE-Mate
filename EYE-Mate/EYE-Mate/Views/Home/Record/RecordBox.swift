//
//  RecordBox.swift
//  EYE-Mate
//
//  Created by seongjun on 1/30/24.
//

import SwiftUI

struct RecordBox: View {
    var body: some View {
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
            VStack {
                Text("검사 이력이 없습니다")
                    .font(.pretendardBold_20)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
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

#Preview {
    RecordBox()
}
