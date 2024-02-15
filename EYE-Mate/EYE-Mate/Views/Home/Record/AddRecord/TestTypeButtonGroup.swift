//
//  TestTypeButtonGroup.swift
//  EYE-Mate
//
//  Created by seongjun on 2/2/24.
//

import SwiftUI

struct TestTypeButtonGroup: View {
    @Binding var selectedID: [String]

    let selectionCallback: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            checkBoxVisionMajority
            checkBoxColorVisionMajority
            checkBoxAstigmatismMajority
            checkBoxEyesightMajority
        }
    }

    var checkBoxVisionMajority: some View {
        CheckBoxButton(
            id: TestType.vision.rawValue,
            label: TestType.vision.rawValue,
            isMarked: selectedID.contains(TestType.vision.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxColorVisionMajority: some View {
        CheckBoxButton(
            id: TestType.colorVision.rawValue,
            label: TestType.colorVision.rawValue,
            isMarked: selectedID.contains(TestType.colorVision.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxAstigmatismMajority: some View {
        CheckBoxButton(
            id: TestType.astigmatism.rawValue,
            label: TestType.astigmatism.rawValue,
            isMarked: selectedID.contains(TestType.astigmatism.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    var checkBoxEyesightMajority: some View {
        CheckBoxButton(
            id: TestType.eyesight.rawValue,
            label: TestType.eyesight.rawValue,
            isMarked: selectedID.contains(TestType.eyesight.rawValue) ? true : false,
            callback: checkBoxGroupCallback
        )
    }

    func checkBoxGroupCallback(id: String) {
        selectionCallback(id)
        if let index = selectedID.firstIndex(of: id) {
            selectedID.remove(at: index)
        } else {
            selectedID.append(id)
        }
    }
}

#Preview {
    @State var selectedID: [String] = []

    return TestTypeButtonGroup(selectedID: $selectedID) { _ in

    }
}
