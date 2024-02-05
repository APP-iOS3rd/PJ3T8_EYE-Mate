//
//  AddRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

struct AddRecordView: View {
    @State private var isVisionRecordVisible = false
    @State private var isColorVisionRecordVisible = false
    @State private var isAstigmatismRecordVisible = false
    @State private var isEyesightRecordVisible = false

    @State private var leftVision = 1.0
    @State private var rightVision = 1.0

    var body: some View {
        VStack {
            AddRecordHeader()
            VStack(spacing: 20){
                AddRecordSubtitleView(label: "검사 날짜")
                HorizontalDivider(color: Color.btnGray, height: 2)

                AddRecordSubtitleView(label: "안경 착용")
                EyewareButtonGroup { selected in
                    print("Selected is: \(selected)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)
                HorizontalDivider(color: Color.btnGray, height: 2)

                AddRecordSubtitleView(label: "검사 장소")
                PlaceButtonGroup { selected in
                    print("Selected is: \(selected)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)
                HorizontalDivider(color: Color.btnGray, height: 2)

                AddRecordSubtitleView(label: "검사 종류")
                TestTypeButtonGroup { selected in
                    if selected == TestType.vision.rawValue {
                        self.isVisionRecordVisible.toggle()
                    }
                    if selected == TestType.colorVision.rawValue {
                        self.isColorVisionRecordVisible.toggle()
                    }
                    if selected == TestType.astigmatism.rawValue {
                        self.isAstigmatismRecordVisible.toggle()
                    }
                    if selected == TestType.eyesight.rawValue {
                        self.isEyesightRecordVisible.toggle()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)

                if isVisionRecordVisible || isColorVisionRecordVisible || isAstigmatismRecordVisible || isEyesightRecordVisible {
                    HorizontalDivider(color: Color.btnGray, height: 2)
                }

                if isVisionRecordVisible {
                    AddRecordSubtitleView(label: "시력")
                    VStack(spacing: 8) {
                        HStack(spacing: 16) {
                            Text("좌").font(.pretendardRegular_14)
                            VStack(spacing: 6) {
                                CustomSlider(
                                    thumbColor: .white,
                                    minTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 1),
                                    maxTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 0.2),
                                    value: $leftVision
                                )
                                Text("\(String(format: "%.1f", leftVision))").font(.pretendardRegular_12)
                            }.padding(.top, 18)
                        }
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                        HStack(spacing: 16) {
                            Text("우").font(.pretendardRegular_14)
                            VStack(spacing: 6) {
                                CustomSlider(
                                    thumbColor: .white,
                                    minTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 1),
                                    maxTrackColor: UIColor(red: 82/255, green: 202/255, blue: 166/255, alpha: 0.2),
                                    value: $rightVision
                                )
                                Text("\(String(format: "%.1f", rightVision))").font(.pretendardRegular_12)
                            }.padding(.top, 18)
                        }
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                    }

                    if isColorVisionRecordVisible || isAstigmatismRecordVisible || isEyesightRecordVisible {
                        HorizontalDivider(color: Color.btnGray, height: 2)
                    }
                }
                if isColorVisionRecordVisible {
                    AddRecordSubtitleView(label: "색각")
                    if isAstigmatismRecordVisible || isEyesightRecordVisible {
                        HorizontalDivider(color: Color.btnGray, height: 2)
                    }
                }
                if isAstigmatismRecordVisible {
                    AddRecordSubtitleView(label: "난시")
                    if isEyesightRecordVisible {
                        HorizontalDivider(color: Color.btnGray, height: 2)
                    }
                }
                if isEyesightRecordVisible {
                    AddRecordSubtitleView(label: "시야")
                }
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
