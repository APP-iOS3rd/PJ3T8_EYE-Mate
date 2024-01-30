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
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(maxWidth: 320)
                            .frame(height: 32)
                            .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                            .foregroundStyle(Color.white)
                            .overlay{
                                Text("23년 11월 21일(월) ~ 24년 01월 17일(수)")
                                    .font(.pretendardRegular_16)
                            }
                        RoundedRectangle(cornerRadius: 16)
                            .frame(maxWidth: 40)
                            .frame(height: 32)
                            .shadow(color: Color(white: 0.0, opacity: 0.25), radius: 6, x: 2, y: 2)
                            .foregroundStyle(Color.white)
                            .overlay{
                                Image(systemName: "plus")
                                    .foregroundStyle(Color.customGreen)
                                    .font(.system(size: 20))
                            }
                    }
                    RecordBox()
                    RecordBox()
                    RecordBox()
                    RecordBox()
                }.padding(16)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(Color.lightGray)
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
        }
    }
}

#Preview {
    RecordView()
}
