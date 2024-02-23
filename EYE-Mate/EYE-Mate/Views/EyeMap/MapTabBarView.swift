//
//  MapTabBarView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/26.
//

import SwiftUI

enum MapTopTapViewItem : String, CaseIterable {
    case hospital = "안과"
    case optician = "안경원"
}

struct MapTabBarView: View {
    @ObservedObject var profileViewModel = ProfileViewModel.shared
    @ObservedObject var coordinator: MapCoordinator = MapCoordinator.shared
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 TabView
            MapTopTabView()
            
            // 선택된 상단 Tab의 View Switching
            switch coordinator.selectedPicker {
            case .hospital:
                MapView()
            case .optician:
                MapView()
            }
        }
    }
    
    
    @ViewBuilder
    func MapTopTabView() -> some View {
        HStack {
            ForEach(MapTopTapViewItem.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .frame(maxWidth: .infinity/2, minHeight: 30)
                        .font(.pretendardBold_24)
                        .foregroundStyle(coordinator.selectedPicker == item ? .black : .gray)
                    
                    if coordinator.selectedPicker == item {
                        Rectangle()
                            .foregroundStyle(Color.customGreen)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "item", in: animation)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        coordinator.selectedPicker = item
                        switch coordinator.selectedPicker {
                        case .hospital:
                            coordinator.queryPlace = encodingPlace.hospital.rawValue
                            coordinator.markerImage = markerImageName.hospital.rawValue
                            coordinator.sheetFlag = false
                        case .optician:
                            coordinator.queryPlace = encodingPlace.optician.rawValue
                            coordinator.markerImage = markerImageName.optician.rawValue
                            coordinator.sheetFlag = false
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    MapTabBarView()
}
