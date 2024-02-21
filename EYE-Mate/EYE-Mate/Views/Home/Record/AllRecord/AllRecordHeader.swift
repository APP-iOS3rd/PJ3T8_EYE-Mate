//
//  AllRecordHeader.swift
//  EYE-Mate
//
//  Created by seongjun on 2/14/24.
//

import SwiftUI

struct AllRecordHeader: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isDeleteMode: Bool
    @Binding var selectedVisionItems: [String]
    @Binding var selectedColorVisionItems: [String]
    @Binding var selectedAstigmatismItems: [String]
    @Binding var selectedEyesightVisionItems: [String]

    let recordType: TestType

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
                    if isDeleteMode {
                        switch recordType {
                        case .vision:
//                            visionItems.removeAll { item in
//                                selectedVisionItems.contains(item.id)
//                            }
                            selectedVisionItems.removeAll()
                        case .colorVision:
//                            colorVisionItems.removeAll { item in
//                                selectedColorVisionItems.contains(item.id)
//                            }
                            selectedColorVisionItems.removeAll()
                        case .astigmatism:
//                            astigmatismItems.removeAll { item in
//                                selectedAstigmatismItems.contains(item.id)
//                            }
                            selectedAstigmatismItems.removeAll()
                        case .eyesight:
//                            eyesightItems.removeAll { item in
//                                selectedEyesightVisionItems.contains(item.id)
//                            }
                            selectedEyesightVisionItems.removeAll()
                        }
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
    }}
