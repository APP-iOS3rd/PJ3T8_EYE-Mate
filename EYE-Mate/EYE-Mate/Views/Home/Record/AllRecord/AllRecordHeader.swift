//
//  AllRecordHeader.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordHeader: View {
    @Environment(\.dismiss) var dismiss

    let recordType: TestType
    let onPressDeleteButton: () -> Void

    private func goBack() {
        dismiss()
    }

    var body: some View {
        ZStack {
            HStack {
                Button {
                    goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 32))
                        .padding(.bottom, 2)
                }
                Spacer()
                Button {
                    onPressDeleteButton()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                        .font(.system(size: 24))
                        .padding(.bottom, 2)
                }
            }.padding(.horizontal, 12)
            HStack {
                Spacer()
                Text("\(recordType.rawValue) 기록 모두보기")
                    .font(.pretendardSemiBold_18)
                Spacer()
            }
        }
    }}

#Preview {
    AllRecordHeader(recordType: TestType.eyesight, onPressDeleteButton: {})
}
