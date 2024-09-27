import Alamofire
import Foundation
import SwiftUI
import Alamofire

class NowModel: ObservableObject {
    @Published var temperature: String = ""
    @Published var rainfall: String = ""
    @Published var humidity: String = ""
    @Published var precipitationType: String = ""
    
    func fetchWeather() {
        let url = "https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getUltraSrtNcst?"
        let parameters: [String: Any] = [
            "authKey": "AqoU-u5aRjCqFPruWgYwxA",
            "numOfRows": 10,
            "pageNo": 1,
            "dataType": "JSON",
            "base_date": "20240927",
            "base_time" : "0900",
            "nx": 55,
            "ny": 127
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
                case .success(let weatherResponse):
                    self.filterWeatherData(items: weatherResponse.response.body.items.item)
                case .failure(let error):
                    print("Error fetching weather: \(error)")
            }
        }
    }
    
    private func filterWeatherData(items: [WeatherItem]) {
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
                        rainfall = item.obsrValue
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
struct WeatherResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let header: Header
    let body: Body
}

struct Header: Codable {
    let resultCode: String
    let resultMsg: String
}

struct Body: Codable {
    let dataType: String
    let items: Items
}

struct Items: Codable {
    let item: [WeatherItem]
}

struct WeatherItem: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let nx: Int
    let ny: Int
    let obsrValue: String
}

