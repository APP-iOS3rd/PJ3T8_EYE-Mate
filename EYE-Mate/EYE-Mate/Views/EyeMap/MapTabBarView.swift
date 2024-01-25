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
    @ObservedObject var coordinator: Coordinator = Coordinator.shared
    @State private var selectedPicker: MapTopTapViewItem = .hospital
    @Namespace private var animation
    
    var body: some View {
        
        NavigationStack{
            VStack(spacing: 0) {
                // 상단 Title
                HStack(alignment: .bottom) {
                    VStack(spacing: 5) {
                        Text("EYE-Mate")
                            .font(.pretendardSemiBold_22)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("주변 정보")
                            .font(.pretendardSemiBold_32)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // MARK: profileImage 추후에 Firebase에서 Image 받아오기
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
                
                // 상단 TabView
                MapTopTabView2(selectedPicker: $selectedPicker)
                
                // 선택된 상단 Tab의 View Switching
                switch selectedPicker {
                case .hospital:
                    MapView()
                case .optician:
                    MapView()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    func MapTopTabView() -> some View {
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

#Preview {
    MapTabBarView()
}
