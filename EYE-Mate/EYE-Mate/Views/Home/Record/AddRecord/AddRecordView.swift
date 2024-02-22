//
//  AddRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

struct AddRecordView: View {
    @EnvironmentObject var router: Router
    @ObservedObject private var recordViewModel = RecordViewModel.shared
    @AppStorage("user_UID") private var userUID: String = "JVGqkutgyQPwq0Cebwtpun5pPeq1"

    @State private var selectedDate: Date = Date()

    @State private var selectedEyeware = ""
    @State private var selectedPlace = ""

    @State private var selectedTestType: [String] = []

    @State private var leftVision = 1.0
    @State private var rightVision = 1.0

    @State private var colorVisionStatus = RecordStatus.nothing

    @State private var leftAstigmatismStatus = RecordStatus.nothing
    @State private var rightAstigmatismStatus = RecordStatus.nothing

    @State private var leftEyesightStatus = RecordStatus.nothing
    @State private var rightEyesightStatus = RecordStatus.nothing

    @State private var selectedEyeStatus: [String] = []

    @State private var selectedSurgery: [String] = []

    var isVisionRecordVisible: Bool {
        selectedTestType.contains(TestType.vision.rawValue)
    }
    var isColorVisionRecordVisible: Bool {
        selectedTestType.contains(TestType.colorVision.rawValue)
    }
    var isAstigmatismRecordVisible: Bool {
        selectedTestType.contains(TestType.astigmatism.rawValue)
    }
    var isEyesightRecordVisible: Bool {
        selectedTestType.contains(TestType.eyesight.rawValue)
    }

    var isCompleteButtonDisabled: Bool {
        if selectedEyeware == "" || selectedPlace == "" || selectedTestType.isEmpty || selectedEyeStatus.isEmpty || selectedSurgery.isEmpty || (isColorVisionRecordVisible && colorVisionStatus == RecordStatus.nothing) || (isAstigmatismRecordVisible && leftAstigmatismStatus == RecordStatus.nothing) || (isAstigmatismRecordVisible && rightAstigmatismStatus == RecordStatus.nothing) || (isEyesightRecordVisible && leftEyesightStatus == RecordStatus.nothing) || (isEyesightRecordVisible && rightEyesightStatus == RecordStatus.nothing){
            return true
        } else {
            return false
        }
    }

    private func goBack() {
        router.navigateBack()
    }

    private func resetRecord() {
        selectedDate = Date()
        selectedEyeware = ""
        selectedPlace = ""
        selectedTestType = []
        leftVision = 1.0
        rightVision = 1.0
        colorVisionStatus = RecordStatus.nothing
        leftAstigmatismStatus = RecordStatus.nothing
        rightAstigmatismStatus = RecordStatus.nothing
        leftEyesightStatus = RecordStatus.nothing
        rightEyesightStatus = RecordStatus.nothing
        selectedEyeStatus = []
        selectedSurgery = []
    }


    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd"

        return formatter
    }()

    var body: some View {
        VStack {
            AddRecordHeader(onPressResetButton: {resetRecord()})
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20){
                        AddRecordSubtitleView(label: "검사 날짜")
                        HStack {
                            Text("\(selectedDate, formatter: AddRecordView.dateFormat)")
                                .font(.pretendardRegular_16)
                                .padding(8)
                                .overlay {
                                    DatePicker(selection: $selectedDate, displayedComponents: .date) {}
                                        .labelsHidden()
                                        .contentShape(Rectangle())
                                        .opacity(0.011)
                                }
                            Spacer()
                        }
                        HorizontalDivider(color: Color.buttonGray, height: 2)

                        AddRecordSubtitleView(label: "안경 착용")
                        EyewareButtonGroup(selectedID: $selectedEyeware) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
                        HorizontalDivider(color: Color.buttonGray, height: 2)

                        AddRecordSubtitleView(label: "검사 장소")
                        PlaceButtonGroup(selectedID: $selectedPlace) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
                        HorizontalDivider(color: Color.buttonGray, height: 2)

                        AddRecordSubtitleView(label: "검사 종류")
                        TestTypeButtonGroup(selectedID: $selectedTestType) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)

                        if isVisionRecordVisible || isColorVisionRecordVisible || isAstigmatismRecordVisible || isEyesightRecordVisible {
                            HorizontalDivider(color: Color.buttonGray, height: 2)
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
                                HorizontalDivider(color: Color.buttonGray, height: 2)
                                    .transition(AnyTransition.opacity.animation(.easeInOut))
                            }
                        }

                        if isColorVisionRecordVisible {
                            VStack {
                                AddRecordSubtitleView(label: "색각")
                                HStack {
                                    CustomMenuButton(label: nil, isColorVision: true, selectedOption: $colorVisionStatus)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                            if isAstigmatismRecordVisible || isEyesightRecordVisible {
                                HorizontalDivider(color: Color.buttonGray, height: 2)
                                    .transition(AnyTransition.opacity.animation(.easeInOut))
                            }
                        }
                        if isAstigmatismRecordVisible {
                            VStack {
                                AddRecordSubtitleView(label: "난시")
                                HStack(spacing: 80) {
                                    CustomMenuButton(label: "좌", isColorVision: false, selectedOption: $leftAstigmatismStatus)
                                    CustomMenuButton(label: "우", isColorVision: false, selectedOption: $rightAstigmatismStatus)
                                }
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                            if isEyesightRecordVisible {
                                HorizontalDivider(color: Color.buttonGray, height: 2)
                                    .transition(AnyTransition.opacity.animation(.easeInOut))
                            }
                        }
                        if isEyesightRecordVisible {
                            VStack {
                                AddRecordSubtitleView(label: "시야")
                                HStack(spacing: 80) {
                                    CustomMenuButton(label: "좌", isColorVision: false, selectedOption: $leftEyesightStatus)
                                    CustomMenuButton(label: "우", isColorVision: false, selectedOption: $rightEyesightStatus)
                                }
                            }
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                        }


                        HorizontalDivider(color: Color.buttonGray, height: 2)
                        AddRecordSubtitleView(label: "눈 진단")
                        EyeStatusButtonGroup(selectedID: $selectedEyeStatus) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)

                        HorizontalDivider(color: Color.buttonGray, height: 2)
                        AddRecordSubtitleView(label: "눈 수술 여부")
                        SurgeryButtonGroup(selectedID: $selectedSurgery) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)

                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 20)
                    .frame(minHeight: geometry.size.height - 92)
                    CustomButton(title: "입력 완료", background: isCompleteButtonDisabled ? Color.customGreen.opacity(0.5) : Color.customGreen, fontStyle: .pretendardSemiBold_22, action: {
                        if isVisionRecordVisible {
                            recordViewModel.createVisionRecord(uid: userUID, visionRecord: VisionRecord(left: String(leftVision), right: String(rightVision), publishedDate: selectedDate))
                        }
                        if isColorVisionRecordVisible {
                            recordViewModel.createColorVisionRecord(uid: userUID, colorVisionRecord: ColorVisionRecord(status: colorVisionStatus.rawValue, publishedDate: selectedDate))
                        }
                        if isAstigmatismRecordVisible {
                            recordViewModel.createAstigmatismRecord(uid: userUID, astigmatismRecord: AstigmatismRecord(left: leftAstigmatismStatus.rawValue, right: rightAstigmatismStatus.rawValue, publishedDate: selectedDate))
                        }
                        if isEyesightRecordVisible {
                            recordViewModel.createEyesightRecord(uid: userUID, eyesightRecord: EyesightRecord(left: leftEyesightStatus.rawValue, right: rightEyesightStatus.rawValue, publishedDate: selectedDate))
                        }
                        goBack()
                    })
                    .frame(height: 88)
                    .frame(maxWidth: .infinity)
                    .disabled(isCompleteButtonDisabled)
                }
            }.navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddRecordView()
}
