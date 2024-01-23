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
    
    var body: some View {
        ZStack {
            NaverMap()
                .ignoresSafeArea(.all, edges: .top)
                
        }
        .onAppear {
            Coordinator.shared.checkIfLocationServiceIsEnabled()
        }
    }
}

struct NaverMap: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator.shared
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        context.coordinator.getNaverMapView()
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {}
    
}

final class Coordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    static let shared = Coordinator()
    // Coordinator 클래스 안의 코드
    // 클래스 상단에 변수 설정을 해줘야 한다.
    @Published var coord: (Double, Double) = (0.0, 0.0)
    @Published var userLocation: (Double, Double) = (0.0, 0.0) // 현재 사용자 위치
    @Published var hospitals: [(Double, Double)] = []
    var locationManager: CLLocationManager?
    
    let view = NMFNaverMapView(frame: .zero)
    
    
    override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.mapView.zoomLevel = 13
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.showLocationButton = true
        view.showZoomControls = true // 줌 확대, 축소 버튼 활성화
        view.showCompass = false
        view.showScaleBar = false
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
        
        // 현재 위치에서 시작
        checkLocationAuthorization()
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라 이동이 시작되기 전 호출되는 함수
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 카메라의 위치가 변경되면 호출되는 함수
    }
    
    // 뷰 함수
    func getNaverMapView() -> NMFNaverMapView {
        view
    }
    
    // location 허용 체크 함수
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
                    self.checkLocationAuthorization()
                }
            } else {
                print("Show an alert letting them know this is off and to go turn i on")
            }
        }
    }
    
    // MARK: - 위치 정보 동의 확인
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Success")
            
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            
            fetchUserLocation()
            fetchApiData()
            
            
        @unknown default:
            break
        }
    }
    
    
    func fetchUserLocation() {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: view.mapView.zoomLevel)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
            locationOverlay.hidden = true
            
            locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
            locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
            view.mapView.moveCamera(cameraUpdate)
            
        }
    }
    
    func fetchApiData() {
        // 현재 내 위치에서 안과 정보 받아오기
        guard let url = URL(string: "https://map.naver.com/v5/api/search?caller=pcweb&query=%EC%95%88%EA%B3%BC&type=all&searchCoord=\(String(userLocation.1));\(String(userLocation.0))&page=1&displayCount=20&isPlaceRecommendationReplace=true&lang=ko") else { return }
        
        // Request
        let request = URLRequest(url: url)
        
        let session = URLSession(configuration: .default)
        // Task
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: error calling GET - \\(String(describing: error))")
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            guard let output = try? JSONDecoder().decode(tempPlaces.self, from: data) else {
                print("Error: JSON data parsing failed")
                return
            }

            DispatchQueue.main.async {
                let resultArray = output.result.place.list
                resultArray.forEach { element in
                    self.hospitals.append((Double(element.y) ?? 0.0, Double(element.x) ?? 0.0))
                    
                    let marker = NMFMarker()
                    marker.position = NMGLatLng(lat: Double(element.y) ?? 0.0, lng: Double(element.x) ?? 0.0)
                    marker.mapView = self.view.mapView
                }
            }
        
            
        }.resume()
    }
}

#Preview {
    MapView()
}
