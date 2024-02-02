//
//  TestTypeButtonGroup.swift
//  EYE-Mate
//
//  Created by seongjun on 2/2/24.
//

import SwiftUI

struct TestTypeButtonGroup: View {
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
            callback: checkoBoxGroupCallback
        )
    }

    var checkBoxColorVisionMajority: some View {
        CheckBoxButton(
            id: TestType.colorVision.rawValue,
            label: TestType.colorVision.rawValue,
            callback: checkoBoxGroupCallback
        )
    }

    var checkBoxAstigmatismMajority: some View {
        CheckBoxButton(
            id: TestType.astigmatism.rawValue,
            label: TestType.astigmatism.rawValue,
            callback: checkoBoxGroupCallback
        )
    }

    var checkBoxEyesightMajority: some View {
        CheckBoxButton(
            id: TestType.eyesight.rawValue,
            label: TestType.eyesight.rawValue,
            callback: checkoBoxGroupCallback
        )
    }

    func checkoBoxGroupCallback(id: String, isMarked: Bool) {
        print("\(id) is marked: \(isMarked)")
    }
}

#Preview {
    TestTypeButtonGroup()
}
