//
//  EyeStatusButtonGroup.swift
//  EYE-Mate
//
//  Created by seongjun on 2/13/24.
//

import SwiftUI

enum EyeStatus: String {
    case noProblem = "문제 없음"
    case nearsighted = "근시"
    case farsighted = "원시"
    case astigmatism = "난시"
}

struct EyeStatusButtonGroup: View {
    @Binding var selectedID: [String]

    let selectionCallback: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            checkBoxNearsightedMajority
            checkBoxFarsightedMajority
            checkBoxAstigmatismMajority
            checkBoxNoProblemMajority
        }
    }

    var checkBoxNearsightedMajority: some View {
        CheckBoxButton(
            id: EyeStatus.nearsighted.rawValue,
            label: EyeStatus.nearsighted.rawValue,
            isMarked: selectedID.contains(EyeStatus.nearsighted.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxFarsightedMajority: some View {
        CheckBoxButton(
            id: EyeStatus.farsighted.rawValue,
            label: EyeStatus.farsighted.rawValue,
            isMarked: selectedID.contains(EyeStatus.farsighted.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxAstigmatismMajority: some View {
        CheckBoxButton(
            id: EyeStatus.astigmatism.rawValue,
            label: EyeStatus.astigmatism.rawValue,
            isMarked: selectedID.contains(EyeStatus.astigmatism.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxNoProblemMajority: some View {
        CheckBoxButton(
            id: EyeStatus.noProblem.rawValue,
            label: EyeStatus.noProblem.rawValue,
            isMarked: selectedID.contains(EyeStatus.noProblem.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    func checkBoxGroupCallback(id: String) {
        selectionCallback(id)
        if let index = selectedID.firstIndex(of: id) {
            selectedID.remove(at: index)
        } else {
            if id == EyeStatus.nearsighted.rawValue {
                if selectedID.contains(EyeStatus.farsighted.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.farsighted.rawValue }
                } else if selectedID.contains(EyeStatus.noProblem.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.noProblem.rawValue }
                }
            } else if id == EyeStatus.farsighted.rawValue {
                if selectedID.contains(EyeStatus.nearsighted.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.nearsighted.rawValue }
                } else if selectedID.contains(EyeStatus.noProblem.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.noProblem.rawValue }
                }
            } else if id == EyeStatus.astigmatism.rawValue {
                if selectedID.contains(EyeStatus.noProblem.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.noProblem.rawValue }
                }
            } else if id == EyeStatus.noProblem.rawValue {
                if selectedID.contains(EyeStatus.nearsighted.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.nearsighted.rawValue }
                }
                if selectedID.contains(EyeStatus.farsighted.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.farsighted.rawValue }
                }
                if selectedID.contains(EyeStatus.astigmatism.rawValue) {
                    selectedID.removeAll { $0 == EyeStatus.astigmatism.rawValue }
                }
            }
            selectedID.append(id)
        }
    }
}

#Preview {
    @State var selectedID: [String] = []

    return EyeStatusButtonGroup(selectedID: $selectedID) { _ in

    }
}
