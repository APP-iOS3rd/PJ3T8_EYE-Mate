//
//  AllRecordHeader.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordHeader: View {
    @EnvironmentObject var router: Router

    @ObservedObject private var recordViewModel = RecordViewModel.shared

    @Binding var isDeleteMode: Bool
    @Binding var isDeleteAlert: Bool

    @Binding var selectedVisionItems: [String]
    @Binding var selectedColorVisionItems: [String]
    @Binding var selectedAstigmatismItems: [String]
    @Binding var selectedEyesightVisionItems: [String]

    let recordType: TestType

    var isRecordsEmpty: Bool {
        switch recordType {
        case .vision:
            return recordViewModel.visionRecords.isEmpty
        case .colorVision:
            return recordViewModel.colorVisionRecords.isEmpty
        case .astigmatism:
            return recordViewModel.astigmatismRecords.isEmpty
        case .eyesight:
            return recordViewModel.eyesightRecords.isEmpty
        }
    }

    var isSelectedRecordsEmpty: Bool {
        switch recordType {
        case .vision:
            return selectedVisionItems.isEmpty
        case .colorVision:
            return selectedColorVisionItems.isEmpty
        case .astigmatism:
            return selectedAstigmatismItems.isEmpty
        case .eyesight:
            return selectedEyesightVisionItems.isEmpty
        }
    }

    private func goBack() {
        router.navigateBack()
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
                if !isRecordsEmpty {
                    Button {
                        if isDeleteMode {
                            if isSelectedRecordsEmpty {
                                isDeleteMode = false
                            } else {
                                isDeleteAlert = true
                            }
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
