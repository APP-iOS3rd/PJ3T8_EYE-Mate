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
                    switch type {
                    case TestType.Vision:
                        Text("시력")
                            .font(.pretendardBold_20)
                        Spacer()
                        Button {
                        } label: {
                            Text("모두보기")
                                .font(.pretendardRegular_14)
                                .foregroundStyle(.black)
                        }
                    case TestType.ColorVision:
                        Text("색각")
                            .font(.pretendardBold_20)
                        Spacer()
                        Button {
                        } label: {
                            Text("모두보기")
                                .font(.pretendardRegular_14)
                                .foregroundStyle(.black)
                        }
                    case TestType.Astigmatism:
                        Text("난시")
                            .font(.pretendardBold_20)
                        Spacer()
                        Button {
                        } label: {
                            Text("모두보기")
                                .font(.pretendardRegular_14)
                                .foregroundStyle(.black)
                        }
                    case TestType.Eyesight:
                        Text("시야")
                            .font(.pretendardBold_20)
                        Spacer()
                        Button {
                        } label: {
                            Text("모두보기")
                                .font(.pretendardRegular_14)
                                .foregroundStyle(.black)
                        }
                    }

                }
                HorizontalDivider(color: Color.lightGray, height: 3)
                VStack(alignment: .leading, spacing: 0) {
                    switch type {
                    case TestType.Vision:
                        VisionDataView()
                    case TestType.ColorVision:
                        ColorVisionDataView()
                    case .Astigmatism:
                        AstigmatismDataView()
                    case .Eyesight:
                        EyesightDataView()
                    }

                }
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.25), radius: 4, x: 2, y: 2)
        }
    }
}

#Preview {
    RecordBox(type: TestType.ColorVision)
}
