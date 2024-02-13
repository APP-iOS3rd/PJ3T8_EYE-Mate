//
//  AddRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

struct AddRecordView: View {
    @Environment(\.dismiss) var dismiss
    
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
    
    private func goBack() {
        dismiss()
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
                        HorizontalDivider(color: Color.btnGray, height: 2)
                        
                        AddRecordSubtitleView(label: "안경 착용")
                        EyewareButtonGroup(selectedID: $selectedEyeware) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
                        HorizontalDivider(color: Color.btnGray, height: 2)
                        
                        AddRecordSubtitleView(label: "검사 장소")
                        PlaceButtonGroup(selectedID: $selectedPlace) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)
                        HorizontalDivider(color: Color.btnGray, height: 2)
                        
                        AddRecordSubtitleView(label: "검사 종류")
                        TestTypeButtonGroup(selectedID: $selectedTestType) { selected in
                            print("Selected is: \(selected)")
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
                                HStack {
                                    CustomMenuButton(label: nil, selectedOption: $colorVisionStatus)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 12)
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
                                HStack(spacing: 80) {
                                    CustomMenuButton(label: "좌", selectedOption: $leftAstigmatismStatus)
                                    CustomMenuButton(label: "우", selectedOption: $rightAstigmatismStatus)
                                }
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


                        HorizontalDivider(color: Color.btnGray, height: 2)
                        AddRecordSubtitleView(label: "눈 진단")
                        EyeStatusButtonGroup(selectedID: $selectedEyeStatus) { selected in
                            print("Selected is: \(selected)")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 12)

                        HorizontalDivider(color: Color.btnGray, height: 2)
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
                    CustomButton(title: "입력완료", background: Color.customGreen, fontStyle: .pretendardSemiBold_22, action: {
                        // TODO: 기록 저장
                        // TODO: 필수 입력 알림 및 disabled 기능 추가
                        goBack()
                    })
                    .frame(height: 88)
                    .frame(maxWidth: .infinity)
                }
            }.navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddRecordView()
}
