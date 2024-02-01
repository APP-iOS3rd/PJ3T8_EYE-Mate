//
//  AddRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

struct AddRecordView: View {
    var body: some View {
        VStack {
            AddRecordHeader()
            VStack(spacing: 20){
                HStack {
                    Rectangle()
                        .frame(width: 5, height: 18)
                        .foregroundStyle(Color.customGreen)
                    Text("검사 날짜")
                        .font(.pretendardRegular_18)
                        .foregroundStyle(Color.darkGray)
                    Spacer()
                }
                HorizontalDivider(color: Color.btnGray, height: 2)
                HStack {
                    Rectangle()
                        .frame(width: 5, height: 18)
                        .foregroundStyle(Color.customGreen)
                    Text("안경 착용")
                        .font(.pretendardRegular_18)
                        .foregroundStyle(Color.darkGray)
                    Spacer()
                }
                EyewareButtonGroup { selected in
                    print("Selected is: \(selected)")
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)
                HorizontalDivider(color: Color.btnGray, height: 2)
                HStack {
                    Rectangle()
                        .frame(width: 5, height: 18)
                        .foregroundStyle(Color.customGreen)
                    Text("검사 장소")
                        .font(.pretendardRegular_18)
                        .foregroundStyle(Color.darkGray)
                    Spacer()
                }
                PlaceButtonGroup { selected in
                    print("Selected is: \(selected)")
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)
                HorizontalDivider(color: Color.btnGray, height: 2)
                HStack {
                    Rectangle()
                        .frame(width: 5, height: 18)
                        .foregroundStyle(Color.customGreen)
                    Text("검사 종류")
                        .font(.pretendardRegular_18)
                        .foregroundStyle(Color.darkGray)
                    Spacer()
                }
                HorizontalDivider(color: Color.btnGray, height: 2)

            }
            .padding(.horizontal, 12)
            .padding(.top, 20)


            Spacer()
        }
    }
}

#Preview {
    AddRecordView()
}
