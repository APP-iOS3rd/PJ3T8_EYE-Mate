//
//  RecordBox.swift
//  EYE-Mate
//
//  Created by seongjun on 1/30/24.
//

import SwiftUI

struct RecordBox: View {
    let type: TestType

    var body: some View {
            VStack {
                VStack(spacing: 16) {
                    HStack {
                        Text(type.rawValue)
                            .font(.pretendardBold_20)
                        Spacer()
                        NavigationLink(destination: AllRecordView(recordType: type)) {
                            Text("모두보기")
                                .font(.pretendardRegular_14)
                                .foregroundStyle(.black)
                        }
                    }
                    HorizontalDivider(color: Color.lightGray, height: 3)
                    VStack(alignment: .leading, spacing: 0) {
                        switch type {
                        case .vision:
                            VisionDataView()
                        case .colorVision:
                            ColorVisionDataView()
                        case .astigmatism:
                            AstigmatismDataView()
                        case .eyesight:
                            EyesightDataView()
                        }

                    }
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
            }
    }
}

#Preview {
    RecordBox(type: .vision)
}
