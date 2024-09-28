import Foundation
import CoreLocation
import Combine
import Alamofire
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var myLocation: String = UserDefaults.standard.string(forKey: "myLocation") ?? ""
    @Published var showAlert = false
    @State private var locations: [String: (String, String,String,String)] = loadCSV()
    @AppStorage("nx") var nx: String = "0"
    @AppStorage("ny") var ny: String = "0"
    @AppStorage("longitude") var longitude: String = "0"
    @AppStorage("latitude") var latitude: String = "0"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestCurrentLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        reverseGeocodeLocation(location: newLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let status = CLLocationManager().authorizationStatus
        if status == .denied || status == .restricted {
            DispatchQueue.main.async {
                            self.showAlert = true
                        }
        }
    }

    public func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func reverseGeocodeLocation(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let apiKey = "6d53b6a7f23ce32315fee9e5e7256035"
        let urlString = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=\(longitude)&y=\(latitude)"

        AF.request(urlString, headers: ["Authorization": "KakaoAK \(apiKey)"]).responseDecodable(of: KakaoGeocodingResponse.self) { response in
            switch response.result {
            case .success(let geocodingResponse):
                if let result = geocodingResponse.documents.first(where: { $0.region_type == "H" }) {
                    DispatchQueue.main.async {
                        self.myLocation = "\(result.address_name)"
                        UserDefaults.standard.set(self.myLocation, forKey: "myLocation")
                        self.nx = self.locations[result.address_name]!.0
                        self.nx = self.locations[result.address_name]!.1
                        self.longitude = self.locations[result.address_name]!.2
                        self.latitude = self.locations[result.address_name]!.3
                    }
                } else {
                    DispatchQueue.main.async {
                        self.myLocation = "주소를 찾을 수 없습니다."
                    }
                }
            case .failure(let error):
                print("API 요청 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.myLocation = "주소를 찾을 수 없습니다."
                }
            }
        }
    }
}


// MARK: - Kakao REST API Struct
struct KakaoGeocodingResponse: Codable {
    let meta: Meta
    let documents: [GeocodingResult]
}

struct Meta: Codable {
    let total_count: Int
}

struct GeocodingResult: Codable {
    let region_type: String
    let code: String
    let address_name: String
}
