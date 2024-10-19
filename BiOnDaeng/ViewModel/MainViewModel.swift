import Foundation
import CoreLocation
import Combine
import Alamofire
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var location: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()
    @Published var myLocation: String = UserDefaults.standard.string(forKey: "myLocation") ?? ""
    @Published var showAlert = false
    @State private var locations: [String: (String, String,String,String)] = loadCSV()
    @AppStorage("nx") var nx: String = "0"
    @AppStorage("ny") var ny: String = "0"
    @AppStorage("longitude") var longitude: String = "0"
    @AppStorage("latitude") var latitude: String = "0"
    @AppStorage("id") private var id: Int = 0
    @AppStorage("uuid") private var uuid: String = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
            locationManager.stopUpdatingLocation()
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location.coordinate
        reverseGeocodeLocation(location: location)
        print("위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
        stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didfailwithError")
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
        let apiKey = Bundle.main.kakaoAppKey
        let urlString = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?x=\(longitude)&y=\(latitude)"

        AF.request(urlString, headers: ["Authorization": "KakaoAK \(apiKey)"]).responseDecodable(of: KakaoGeocodingResponse.self) { response in
            switch response.result {
            case .success(let geocodingResponse):
                if let result = geocodingResponse.documents.first(where: { $0.region_type == "H" }) {
                    DispatchQueue.main.async {
                        self.myLocation = "\(result.address_name)"
                        UserDefaults.standard.set(self.myLocation, forKey: "myLocation")
                        self.nx = self.locations[result.address_name]!.0
                        self.ny = self.locations[result.address_name]!.1
                        self.longitude = self.locations[result.address_name]!.2
                        self.latitude = self.locations[result.address_name]!.3
                        self.fetchRecordID(using: self.uuid)
                        self.updateLocationInDatabase()
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
    
    func updateLocationInDatabase() {
        let url = "http://211.188.54.174:1337/alarms/\(id)"
        let parameters: [String: Any] = [
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("위치 정보가 성공적으로 업데이트되었습니다.")
                case .failure(let error):
                    print("위치 정보 업데이트 실패: \(error)")
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 응답: \(errorMessage)")
                    }
                }
            }
    }
    
    func fetchRecordID(using uuid: String) {
        let url = "http://211.188.54.174:1337/alarms?uuid=\(uuid)"
        
        AF.request(url)
               .validate()
               .responseDecodable(of: [Record].self) { response in
                   switch response.result {
                   case .success(let records):
                       if let firstRecord = records.first {
                           self.id = firstRecord.id
                           print(firstRecord.id)
                       } else {
                       }
                   case .failure(let error):
                       print("Error: \(error)")
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
