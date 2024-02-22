//
//  MapView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/23.
//
import SwiftUI
import NMapsMap
import CoreLocation

struct MapView: View {
    @StateObject var coordinator: MapCoordinator = MapCoordinator.shared
    @State var updateButton: Bool = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            NaverMap()
                .ignoresSafeArea(.all, edges: .top)
            VStack{
                Button{
                    updateButton.toggle()
                    if updateButton {
                        MapCoordinator.shared.fetchApiData()
                        updateButton = false
                    }
                } label: {
                    Text("\(Image(systemName: "arrow.clockwise")) 현 지도에서 검색")
                        .foregroundColor(.white)
                        .font(.pretendardSemiBold_14)
                        .frame(width: 129.0, height: 34.0)
                        .background(Color.customGreen)
                        .opacity(0.8)
                        .cornerRadius(20.0)
                        .padding()
                }
                
                Spacer()
                
                if coordinator.sheetFlag {
                    MapModalView()
                        .transition(.move(edge: .bottom))
                }
            }
            .padding(.bottom, 20)
        }
        .onAppear {
            MapCoordinator.shared.checkIfLocationServiceIsEnabled()
        }
    }
}

#Preview {
    MapView()
}
