//
//  AddRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

struct AddRecordView: View {
    @Environment(\.dismiss) var dismiss

    @State private var isVisionRecordVisible = false
    @State private var isColorVisionRecordVisible = false
    @State private var isAstigmatismRecordVisible = false
    @State private var isEyesightRecordVisible = false

    @State private var leftVision = 1.0
    @State private var rightVision = 1.0

    @State private var leftColorVisionStatus = RecordStatus.nothing
    @State private var rightColorVisionStatus = RecordStatus.nothing

    @State private var astigmatismStatus = RecordStatus.nothing

    @State private var leftEyesightStatus = RecordStatus.nothing
    @State private var rightEyesightStatus = RecordStatus.nothing

    private func goBack() {
        dismiss()
    }

    var body: some View {
        VStack {
            AddRecordHeader()
            GeometryReader { geometry in
                ScrollView {
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
                                .transition(AnyTransition.opacity.animation(.easeInOut))
                        }

                        if isVisionRecordVisible {
                            VStack {
                                AddRecordSubtitleView(label: "시력")
                                VStack(spacing: 8) {
                                    VisionSlider(value: $leftVision, label: "좌")
                                    VisionSlider(value: $rightVision, label: "우")
                                }
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut))


                            if isColorVisionRecordVisible || isAstigmatismRecordVisible || isEyesightRecordVisible {
                                HorizontalDivider(color: Color.btnGray, height: 2)
                                    .transition(AnyTransition.opacity.animation(.easeInOut))
                            }
                        }

                        if isColorVisionRecordVisible {
                            VStack {
                                AddRecordSubtitleView(label: "색각")
                                HStack(spacing: 80) {
                                    CustomMenuButton(label: "좌", selectedOption: $leftColorVisionStatus)
                                    CustomMenuButton(label: "우", selectedOption: $rightColorVisionStatus)
                                }
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                            if isAstigmatismRecordVisible || isEyesightRecordVisible {
                                HorizontalDivider(color: Color.btnGray, height: 2)
                                    .transition(AnyTransition.opacity.animation(.easeInOut))
                            }
                        }
                        if isAstigmatismRecordVisible {
                            VStack {
                                AddRecordSubtitleView(label: "난시")
                                CustomMenuButton(label: nil, selectedOption: $astigmatismStatus)
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                            if isEyesightRecordVisible {
                                HorizontalDivider(color: Color.btnGray, height: 2)
                                    .transition(AnyTransition.opacity.animation(.easeInOut))
                            }
                        }
                        if isEyesightRecordVisible {
                            VStack {
                                AddRecordSubtitleView(label: "시야")
                                HStack(spacing: 80) {
                                    CustomMenuButton(label: "좌", selectedOption: $leftEyesightStatus)
                                    CustomMenuButton(label: "우", selectedOption: $rightEyesightStatus)
                                }
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 20)
                    .frame(minHeight: geometry.size.height - 92)
                    CustomButton(title: "입력완료", background: Color.customGreen, fontStyle: .pretendardSemiBold_22, action: {
                        // TODO: 기록 저장
                        goBack()
                    })
                    .frame(height: 88)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    AddRecordView()
}
