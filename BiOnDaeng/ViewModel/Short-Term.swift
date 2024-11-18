import SwiftUI
import Alamofire

class ShortTermModel: ObservableObject {
    @AppStorage("nx") var nx: String = "0"
    @AppStorage("ny") var ny: String = "0"
    
    @Published var pop: [String] = []
    @Published var pty: [String] = []
    @Published var tmx: String = ""
    @Published var tmn: String = ""
    
    func fetchTmxTmn() {
        let url = "https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getVilageFcst"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let baseDate = dateFormatter.string(from: yesterday!)
        let baseTime = "2000"
        
        let parameters: [String: Any] = [
            "authKey": Bundle.main.gisangAuth,
            "numOfRows": 1000,
            "pageNo": 1,
            "dataType": "JSON",
            "base_date": baseDate,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: STWeatherResponse.self) { response in
            switch response.result {
                case .success(let weatherResponse):
                    self.filterTmxTmnData(items: weatherResponse.response.body.items.item)
                case .failure(let error):
                    print("Error fetching Tmx/Tmn: \(error)")
            }
        }
    }
    
    func fetchPopPty() {
        let url = "https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/getVilageFcst"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        var baseDate = dateFormatter.string(from: Date())
        
        let currentHour = Calendar.current.component(.hour, from: Date())
        let currentMinute = Calendar.current.component(.minute, from: Date())
        
        var baseTime: String
        
        if (currentHour < 2) || (currentHour == 2 && currentMinute < 10) {
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            baseDate = dateFormatter.string(from: yesterday!)
            baseTime = "2300"
        } else {
            let availableBaseTimes = ["0200", "0500", "0800", "1100", "1400", "1700", "2000", "2300"]
            baseTime = "2300"
            for time in availableBaseTimes {
                let hour = Int(time.prefix(2))!
                let minute = Int(time.suffix(2))!
                
                if currentHour > hour || (currentHour == hour && currentMinute >= minute + 10) {
                    baseTime = time
                } else {
                    break
                }
            }
        }
        
        pop.removeAll()
        pty.removeAll()
        
        let parameters: [String: Any] = [
            "authKey": "AqoU-u5aRjCqFPruWgYwxA",
            "numOfRows": 1000,
            "pageNo": 1,
            "dataType": "JSON",
            "base_date": baseDate,
            "base_time": baseTime,
            "nx": nx,
            "ny": ny
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: STWeatherResponse.self) { response in
            switch response.result {
                case .success(let weatherResponse):
                    self.filterPopPtyData(items: weatherResponse.response.body.items.item)
                case .failure(let error):
                    print("Error fetching Pop/Pty: \(error)")
            }
        }
    }
    
    private func filterPopPtyData(items: [STWeatherItem]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHH00"

        let currentDateTime = Date()
        let calendar = Calendar.current
        
        var targetTimes: [String] = []
        
        for hour in 1...24 {
            let targetDate = calendar.date(byAdding: .hour, value: hour, to: currentDateTime)!
            let targetTimeString = dateFormatter.string(from: targetDate)
            targetTimes.append(targetTimeString)
        }

        for item in items {
            let fcstDate = item.fcstDate
            let fcstTime = item.fcstTime.prefix(4)

            let formattedTargetTime = "\(fcstDate)\(fcstTime)"
            if targetTimes.contains(formattedTargetTime) {
                if item.category == "POP" {
                    pop.append(item.fcstValue)
                } else if item.category == "PTY" {
                    pty.append(item.fcstValue)
                }
            }
        }
    }
    
    private func filterTmxTmnData(items: [STWeatherItem]) {
        var foundTmx = false
        var foundTmn = false
        
        for item in items {
            if item.category == "TMX", !foundTmx {
                tmx = item.fcstValue
                foundTmx = true
            } else if item.category == "TMN", !foundTmn {
                tmn = item.fcstValue
                foundTmn = true
            }
            if foundTmx && foundTmn {
                break
            }
        }
    }
}


//MARK: - 단기 예보 API 데이터 모델
struct STWeatherResponse: Codable {
    let response: STResponse
}

struct STResponse: Codable {
    let header: STHeader
    let body: STBody
}

struct STHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct STBody: Codable {
    let dataType: String
    let items: STItems
}

struct STItems: Codable {
    let item: [STWeatherItem]
}

struct STWeatherItem: Codable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
}
