//
//  MapTopTabView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/26.
//

import SwiftUI


struct MapTopTabView2: View {
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    @Binding var selectedPicker: MapTopTapViewItem
    @Namespace private var animation
    
    var body: some View {
        HStack {
            ForEach(MapTopTapViewItem.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity/2, minHeight: 30)
                        .font(.pretendardBold_24)
                        .foregroundStyle(selectedPicker == item ? .black : .gray)
                    
                    if selectedPicker == item {
                        Rectangle()
                            .foregroundStyle(Color.customGreen)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "item", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        self.selectedPicker = item
                        switch self.selectedPicker {
                        case .hospital:
                            coordinator.queryPlace = encodingPlace.hosiptal.rawValue
                        case .optician:
                            coordinator.queryPlace = encodingPlace.optician.rawValue
                        }
                    }
                }
            }
        }
    }
}

