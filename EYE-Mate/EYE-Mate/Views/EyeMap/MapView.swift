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
    // Coordinator 클래스
    @StateObject var coordinator: Coordinator = Coordinator.shared
    @State var updateBtn: Bool = false
    @State private var isHover = false
    var body: some View {
        
        ZStack(alignment: .top) {
            NaverMap()
                .ignoresSafeArea(.all, edges: .top)
            VStack{
                Button{
                    updateBtn.toggle()
                    if updateBtn {
                        Coordinator.shared.fetchApiData()
                        updateBtn = false
                    }
                } label: {
                    Text("\(Image(systemName: "arrow.clockwise")) 현 지도에서 검색")
                        .foregroundColor(.white)
                        .font(.pretendardSemiBold_14)
                        .frame(width: 129.0, height: 34.0)
                        .background(Color.customGreen)
                        .opacity(0.8)
                        .cornerRadius(20.0)
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
            Coordinator.shared.checkIfLocationServiceIsEnabled()
        }
    }
}

#Preview {
    MapView()
}
