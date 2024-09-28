import SwiftUI

func loadCSV() -> [String: (x: String, y: String, longitude: String, latitude: String)] {
    guard let path = Bundle.main.path(forResource: "동네예보지점좌표240101", ofType: "csv") else {
        print("파일 경로를 찾을 수 없습니다.")
        return [:]
    }
    
    do {
        let data = try String(contentsOfFile: path)
        let rows = data.components(separatedBy: "\n").dropFirst()
        
        var locations: [String: (x: String, y: String, longitude: String, latitude: String)] = [:]
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            
            let region = columns[2]
            let district = columns[3]
            let neighborhood = columns[4]
            let xCoordinate = columns[5]
            let yCoordinate = columns[6]
            let longitude = columns[13] // 경도
            let latitude = columns[14] // 위도
            
            let locationName = "\(region) \(district) \(neighborhood)"
                .trimmingCharacters(in: .whitespaces)
            
            locations[locationName] = (x: xCoordinate, y: yCoordinate, longitude: longitude, latitude: latitude)
    }
    
    return locations
} catch {
    print("CSV 파일을 읽는 중 오류 발생: \(error)")
    return [:]
    }
}
