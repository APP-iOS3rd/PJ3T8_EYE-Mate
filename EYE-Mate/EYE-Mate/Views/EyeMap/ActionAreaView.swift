//
//  ActionAreaView.swift
//  EYE-Mate
//
//  Created by 이민영 on 2024/01/25.
//

import SwiftUI

struct ActionAreaView: View {
    @ObservedObject var coordinator: MapCoordinator
    
    var body: some View {
        VStack {
            AsyncImageView(url: URL(string: coordinator.placeInfo[Key.image.rawValue] ?? ""))

            Button(action: {
                showNaverMap(lat: Double(coordinator.placeInfo[Key.lat.rawValue] ?? "0.0")!,lng: Double(coordinator.placeInfo[Key.lng.rawValue] ?? "0.0")!, name: coordinator.placeInfo[Key.name.rawValue] ?? "도착")
            }) {
                Label("길찾기", systemImage: "location")
            }
            .buttonStyle(MapButtonStyle())
        }
    }
    
    func showNaverMap(lat: Double, lng: Double, name: String) {
        // 자동차 길찾기 + 도착지 좌표 + 앱 번들 id
        guard let url = URL(string: "nmap://route/public?dlat=\(lat)&dlng=\(lng)&dname=\(name)&appname=Seonghyeon.EYE-Mate") else { return }
        // 네이버지도 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }

        // 네이버지도 앱이 존재 한다면,
        if UIApplication.shared.canOpenURL(url) {
            // 길찾기 open
            UIApplication.shared.open(url)
        } else { // 네이버지도 앱이 없다면,
            // 네이버지도 앱 설치 앱스토어로 이동
            UIApplication.shared.open(appStoreURL)
        }
    }
}




