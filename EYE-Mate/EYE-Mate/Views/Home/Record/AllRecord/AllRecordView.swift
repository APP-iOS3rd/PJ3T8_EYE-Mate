//
//  AllRecordView.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct VisionRecordModel: Identifiable & Hashable {
    let id = UUID()
    let date: Date
    let place: String
    let left: Double
    let right: Double
}

struct ColorVisionRecordModel: Identifiable & Hashable {
    let id = UUID()
    let date: Date
    let place: String
    let status: RecordStatus
}

struct AstigmatismRecordModel: Identifiable & Hashable {
    let id = UUID()
    let date: Date
    let place: String
    let left: RecordStatus
    let right: RecordStatus
}

struct EyesightRecordModel: Identifiable & Hashable {
    let id = UUID()
    let date: Date
    let place: String
    let left: RecordStatus
    let right: RecordStatus
}

struct AllRecordView: View {
    let recordType: TestType

    @State private var isDeleteMode = false
    @State private var visionItems: [VisionRecordModel] =
    [
        VisionRecordModel(date: Date(), place: "EYE-Mate", left: 0.3, right: 0.7),
        VisionRecordModel(date: Date(), place: "EYE-Mate", left: 0.3, right: 0.7),
        VisionRecordModel(date: Date(), place: "EYE-Mate", left: 0.3, right: 0.7)
    ]

    @State private var colorVisionItems: [ColorVisionRecordModel] =
    [
        ColorVisionRecordModel(date: Date(), place: "EYE-Mate", status: .normal),
        ColorVisionRecordModel(date: Date(), place: "EYE-Mate", status: .serious),
        ColorVisionRecordModel(date: Date(), place: "EYE-Mate", status: .severe)
    ]

    @State private var astigmatismItems: [AstigmatismRecordModel] =
    [
        AstigmatismRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .good),
        AstigmatismRecordModel(date: Date(), place: "EYE-Mate", left: .fine, right: .fine),
        AstigmatismRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .fine)
    ]

    @State private var eyesightItems: [EyesightRecordModel] =
    [
        EyesightRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .good),
        EyesightRecordModel(date: Date(), place: "EYE-Mate", left: .fine, right: .fine),
        EyesightRecordModel(date: Date(), place: "EYE-Mate", left: .bad, right: .fine)
    ]

    @State private var selectedVisionItems: [UUID] = []
    @State private var selectedColorVisionItems: [UUID] = []
    @State private var selectedAstigmatismItems: [UUID] = []
    @State private var selectedEyesightVisionItems: [UUID] = []

    var body: some View {
        // FIXME: 전역으로 상태 관리하는 방법이 있을 것 같음
        VStack {
            AllRecordHeader(isDeleteMode: $isDeleteMode, visionItems: $visionItems, colorVisionItems: $colorVisionItems, astigmatismItems: $astigmatismItems, eyesightItems: $eyesightItems, selectedVisionItems: $selectedVisionItems, selectedColorVisionItems: $selectedColorVisionItems, selectedAstigmatismItems: $selectedAstigmatismItems, selectedEyesightVisionItems: $selectedEyesightVisionItems, recordType: recordType )
            AllRecordList(isDeleteMode: $isDeleteMode, recordType: recordType, visionItems: $visionItems, colorVisionItems: $colorVisionItems, astigmatismItems: $astigmatismItems, eyesightItems: $eyesightItems, selectedVisionItems: $selectedVisionItems, selectedColorVisionItems: $selectedColorVisionItems, selectedAstigmatismItems: $selectedAstigmatismItems, selectedEyesightVisionItems: $selectedEyesightVisionItems)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    AllRecordView(recordType: TestType.eyesight)
}
