//
//  MapView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/23.
//
import SwiftUI
import NMapsMap

struct MapView: View {
    @State var coord: (Double, Double) = (126.9784147, 37.5666805)
    @State var name: String = ""
    
    var body: some View {
        VStack {
            UIMapView(coord: coord)
                .ignoresSafeArea(.all)
        }

    }
    
}

struct UIMapView: UIViewRepresentable {
    var coord: (Double, Double)
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        let view = NMFNaverMapView()
        view.showZoomControls = false
        view.mapView.positionMode = .direction
        view.mapView.zoomLevel = 17
        
        return view
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        let coord = NMGLatLng(lat: coord.1, lng: coord.0)
        let cameraUpdate = NMFCameraUpdate(scrollTo: coord)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1
        uiView.mapView.moveCamera(cameraUpdate)
    }
    
}

#Preview {
    MapView()
}
