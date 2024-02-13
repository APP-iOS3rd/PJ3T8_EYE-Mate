//
//  SurgeryButtonGroup.swift
//  EYE-Mate
//
//  Created by seongjun on 2/13/24.
//

import SwiftUI

enum Surgery: String {
    case presbyopia = "노안 수술"
    case correction = "시력 교정 (라식/라섹)"
    case cataract = "백내장 수술"
    case etc = "기타"
    case nothing = "없음"
}

struct SurgeryButtonGroup: View {
    @Binding var selectedID: [String]

    let selectionCallback: (String) -> Void

    var body: some View {
        WrappingHStack(horizontalSpacing: 12) {
            checkBoxPresbyopiaMajority
            checkBoxCorrectionMajority
            checkBoxCataractMajority
            checkBoxEtcMajority
            checkBoxNothingMajority
        }
    }

    var checkBoxPresbyopiaMajority: some View {
        CheckBoxButton(
            id: Surgery.presbyopia.rawValue,
            label: Surgery.presbyopia.rawValue,
            isMarked: selectedID.contains(Surgery.presbyopia.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxCorrectionMajority: some View {
        CheckBoxButton(
            id: Surgery.correction.rawValue,
            label: Surgery.correction.rawValue,
            isMarked: selectedID.contains(Surgery.correction.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxCataractMajority: some View {
        CheckBoxButton(
            id: Surgery.cataract.rawValue,
            label: Surgery.cataract.rawValue,
            isMarked: selectedID.contains(Surgery.cataract.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxEtcMajority: some View {
        CheckBoxButton(
            id: Surgery.etc.rawValue,
            label: Surgery.etc.rawValue,
            isMarked: selectedID.contains(Surgery.etc.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxNothingMajority: some View {
        CheckBoxButton(
            id: Surgery.nothing.rawValue,
            label: Surgery.nothing.rawValue,
            isMarked: selectedID.contains(Surgery.nothing.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    func checkBoxGroupCallback(id: String) {
        selectionCallback(id)
        if let index = selectedID.firstIndex(of: id) {
            selectedID.remove(at: index)
        } else {
            if id == Surgery.nothing.rawValue {
                if selectedID.contains(Surgery.presbyopia.rawValue) {
                    selectedID.removeAll { $0 == Surgery.presbyopia.rawValue }
                }
                if selectedID.contains(Surgery.correction.rawValue) {
                    selectedID.removeAll { $0 == Surgery.correction.rawValue }
                }
                if selectedID.contains(Surgery.cataract.rawValue) {
                    selectedID.removeAll { $0 == Surgery.cataract.rawValue }
                }
                if selectedID.contains(Surgery.etc.rawValue) {
                    selectedID.removeAll { $0 == Surgery.etc.rawValue }
                }
            } else {
                if selectedID.contains(Surgery.nothing.rawValue) {
                    selectedID.removeAll { $0 == Surgery.nothing.rawValue }
                }
            }
            selectedID.append(id)
        }
    }
}

#Preview {
    @State var selectedID: [String] = []

    return SurgeryButtonGroup(selectedID: $selectedID) { _ in

    }
}
