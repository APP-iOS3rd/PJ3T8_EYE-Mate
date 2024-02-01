//
//  PlaceButtonGroup.swift
//  EYE-Mate
//
//  Created by seongjun on 2/1/24.
//

import SwiftUI

enum TestPlace: String {
    case ophthalmology = "안과"
    case optician = "안경원"
}

struct PlaceButtonGroup: View {
    let callback: (String) -> ()

    @State var selectedId: String = ""

    var body: some View {
        HStack(spacing: 12) {
            radioOphthalmologyMajority
            radioOpticianMajority
        }
    }

    var radioOphthalmologyMajority: some View {
        RadioButton(
            id: TestPlace.ophthalmology.rawValue,
            label: TestPlace.ophthalmology.rawValue,
            isMarked: selectedId == TestPlace.ophthalmology.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    var radioOpticianMajority: some View {
        RadioButton(
            id: TestPlace.optician.rawValue,
            label: TestPlace.optician.rawValue,
            isMarked: selectedId == TestPlace.optician.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }

    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}

#Preview {
    PlaceButtonGroup{ selected in
        print("Selected is: \(selected)")
    }
}
