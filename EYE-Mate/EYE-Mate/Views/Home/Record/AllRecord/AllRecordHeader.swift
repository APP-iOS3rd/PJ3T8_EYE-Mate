//
//  AllRecordHeader.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordHeader: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var recordViewModel = RecordViewModel.shared

    @Binding var isDeleteMode: Bool
    @Binding var selectedVisionItems: [String]
    @Binding var selectedColorVisionItems: [String]
    @Binding var selectedAstigmatismItems: [String]
    @Binding var selectedEyesightVisionItems: [String]

    let recordType: TestType

    private func goBack() {
        dismiss()
    }

    private func deleteSelectedItems() {
        switch recordType {
        case .vision:
            selectedVisionItems.forEach { id in
                if let record = recordViewModel.visionRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteVisionRecord(record: record)
                }
            }
        case .colorVision:
            selectedColorVisionItems.forEach { id in
                if let record = recordViewModel.colorVisionRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteColorVisionRecord(record: record)
                }
            }
        case .astigmatism:
            selectedAstigmatismItems.forEach { id in
                if let record = recordViewModel.astigmatismRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteAstigmatismVisionRecord(record: record)
                }
            }
        case .eyesight:
            selectedEyesightVisionItems.forEach { id in
                if let record = recordViewModel.eyesightRecords.first(where: { $0.id == id }) {
                    recordViewModel.deleteEyesightVisionRecord(record: record)
                }
            }
        }

        switch recordType {
        case .vision:
            selectedVisionItems.removeAll()
        case .colorVision:
            selectedColorVisionItems.removeAll()
        case .astigmatism:
            selectedAstigmatismItems.removeAll()
        case .eyesight:
            selectedEyesightVisionItems.removeAll()
        }
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
                    if isDeleteMode {
                        deleteSelectedItems()
                        isDeleteMode = false
                    } else {
                        isDeleteMode = true
                    }
                } label: {
                    if isDeleteMode {
                        Text("완료")
                            .foregroundStyle(.blue)
                    } else {
                        Image(systemName: "trash")
                            .foregroundColor(.black)
                            .font(.system(size: 24))
                            .padding(.bottom, 2)
                    }
                }
            }.padding(.horizontal, 12)
            HStack {
                Spacer()
                Text("\(recordType.rawValue) 기록 모두보기")
                    .font(.pretendardSemiBold_18)
                Spacer()
            }
        }
        .onChange(of: isDeleteMode) { newValue in
            if !newValue {
                switch recordType {
                case .vision:
                    selectedVisionItems.removeAll()
                case .colorVision:
                    selectedColorVisionItems.removeAll()
                case .astigmatism:
                    selectedAstigmatismItems.removeAll()
                case .eyesight:
                    selectedEyesightVisionItems.removeAll()
                }
            }
        }
    }}
