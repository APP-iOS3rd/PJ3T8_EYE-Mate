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
    @Published var placeInfo: [String: String] = [:]
    @Published var sheetFlag = false
    
    var hospitalsMarkers: [NMFMarker] = []
    var locationManager: CLLocationManager?
    
    let view = NMFNaverMapView(frame: .zero)
    
    
    override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.mapView.zoomLevel = 14
        view.mapView.minZoomLevel = 10 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.mapView.isZoomGestureEnabled = true
        view.showLocationButton = true
        view.showZoomControls = true // 줌 확대, 축소 버튼 활성화
        view.showCompass = false
        view.showScaleBar = false
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
        
        // 현재 위치에서 시작
        checkLocationAuthorization()
    }
    
    // 카메라 이동이 시작되기 전 호출되는 함수
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
    }
    
    // 카메라 위치가 변경되면 호출되는 함수
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        let cameraPosition = mapView.cameraPosition
        coord = (cameraPosition.target.lat, cameraPosition.target.lng)
    }
    
    // 지도 터치하면 호출되는 함수(마커가 터치될 땐 호출 X)
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        withAnimation(.linear(duration: 0.25)) {
            sheetFlag = false
        }
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
            
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            
            coord = userLocation
            
            fetchUserLocation()
            fetchApiData()
            
        @unknown default:
            break
        }
    }
    
    // MARK: - 사용자 실제 위치 기준 icon 설정
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
    
    // MARK: - 위치 주변 안과 정보 받아오기
    func fetchApiData() {
        // 모든 hospitals, coord 전부 latitude, longitude 순서
        // query = longitude, latitude 순서
        guard let url = URL(string: "https://map.naver.com/v5/api/search?caller=pcweb&query=%EC%95%88%EA%B3%BC&type=all&searchCoord=\(String(coord.1));\(String(coord.0))&page=1&displayCount=40&isPlaceRecommendationReplace=true&lang=ko") else { return }
        
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
            guard let output = try? JSONDecoder().decode(Places.self, from: data) else {
                print("Error: JSON data parsing failed")
                return
            }
            
            DispatchQueue.main.async {
                // 거리에 따른 정렬
                var array = output.result.place.list
                array.sort { return Double($0.distance) ?? 0.0 < Double($1.distance) ?? 0.0 }
                // 내 주변 20개 보여주기
                let resultArray = Array(array[0...19])
                //                print(resultArray)
                
                // 이전 마커 지우기
                if self.hospitalsMarkers.count > 1 {
                    self.hospitalsMarkers.forEach { element in
                        element.mapView = nil
                    }
                }
                
                // 위치 기준 새로운 마커 생성
                var markNumber: Int = -1 // 마커 식별자 테그
                var placeIdx: Int = 0
                resultArray.forEach { element in
                    markNumber += 1
                    self.hospitals.append((Double(element.y) ?? 0.0, Double(element.x) ?? 0.0))
                    
                    let marker = NMFMarker()
                    marker.position = NMGLatLng(lat: Double(element.y) ?? 0.0, lng: Double(element.x) ?? 0.0)
                    marker.iconImage = NMFOverlayImage(name: "hospital_mark")
                    marker.width = 50
                    marker.height = 50
                    marker.mapView = self.view.mapView
                    marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                        // 눌렀을때 정보 나오게
                        print(resultArray[Int(marker.tag)])
                        placeIdx = Int(marker.tag)
                        self.placeInfo["name"] = resultArray[placeIdx].name
                        self.placeInfo["status"] = resultArray[placeIdx].businessStatus.status.text
                        self.placeInfo["statusDetail"] = resultArray[placeIdx].businessStatus.status.detailInfo
                        self.placeInfo["image"] = resultArray[placeIdx].thumUrls.first ?? nil
                        self.placeInfo["reviewCount"] = String(resultArray[placeIdx].reviewCount)
                        self.placeInfo["placeReviewCount"] = String(resultArray[placeIdx].placeReviewCount)
                        self.placeInfo["address"] = resultArray[placeIdx].address
                        self.placeInfo["tel"] = resultArray[placeIdx].tel
                        withAnimation(.linear(duration: 0.25)) {
                            self.sheetFlag = true
                        }
                        
                        return true // 이벤트 소비, -mapView:didTapMap:point 이벤트는 발생하지 않음
                    }
                    marker.tag = UInt(markNumber)
                    self.hospitalsMarkers.append(marker)
                }
            }
        }.resume()
    }
}

#Preview {
    MapView()
}
