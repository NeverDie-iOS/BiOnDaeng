import Alamofire
import Foundation
import SwiftUI

class NowModel: ObservableObject {
    @AppStorage("nx") var nx: String = "0"
    @AppStorage("ny") var ny: String = "0"
    
    @Published var temperature: String = ""
    @Published var rainfall: String = ""
    @Published var humidity: String = ""
    @Published var precipitationType: String = ""
    
    func fetchWeather() {
        let url = "https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getUltraSrtNcst"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        var baseDate = dateFormatter.string(from: Date())
        
        let currentDate = Date()
        dateFormatter.dateFormat = "HH"
        let currentHour = Int(dateFormatter.string(from: currentDate)) ?? 0
        dateFormatter.dateFormat = "mm"
        let currentMinute = Int(dateFormatter.string(from: currentDate)) ?? 0
        
        var baseTime: String
        
        if currentHour == 0 && currentMinute < 10 {
            baseDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!)
            baseTime = "2300"
        } else if currentMinute >= 10 {
            baseTime = String(format: "%02d00", currentHour)
        } else {
            let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: currentDate)!
            let oneHourAgoHour = Calendar.current.component(.hour, from: oneHourAgo)
            baseTime = String(format: "%02d00", oneHourAgoHour)
        }
        
        let parameters: [String: Any] = [
            "authKey": Bundle.main.gisangAuth,
            "numOfRows": 10,
            "pageNo": 1,
            "dataType": "JSON",
            "base_date": baseDate,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: NWeatherResponse.self) { response in
            switch response.result {
                case .success(let weatherResponse):
                    self.filterWeatherData(items: weatherResponse.response.body.items.item)
                case .failure(let error):
                    print("Error fetching weather: \(error)")
            }
        }
    }

    
    private func filterWeatherData(items: [NWeatherItem]) {
        rainfall = ""
        for item in items {
            switch item.category {
                case "T1H":
                    if let tempValue = Double(item.obsrValue) {
                        temperature = String(Int(tempValue))
                    }
                case "RN1":
                    if item.obsrValue == "0" {
                        rainfall += item.obsrValue + "mm"
                    } else if item.obsrValue == "30.0~50.0mm" {
                        rainfall = "30mm이상"
                    } else if item.obsrValue == "50mm 이상" {
                        rainfall = "50mm이상"
                    } else {
                        rainfall = item.obsrValue + "mm"
                    }
                case "REH":
                    humidity = item.obsrValue
                case "PTY":
                    precipitationType = item.obsrValue
                default:
                    break
            }
        }
    }
}

//MARK: - 초단기 실황 API 데이터 모델
struct NWeatherResponse: Codable {
    let response: NResponse
}

struct NResponse: Codable {
    let header: NHeader
    let body: NBody
}

struct NHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct NBody: Codable {
    let dataType: String
    let items: NItems
}

struct NItems: Codable {
    let item: [NWeatherItem]
}

struct NWeatherItem: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let nx: Int
    let ny: Int
    let obsrValue: String
}
