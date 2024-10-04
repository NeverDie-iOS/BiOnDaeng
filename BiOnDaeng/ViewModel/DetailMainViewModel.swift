import SwiftUI
import Combine
import Alamofire
import AVKit

struct CCTVResponse: Codable {
    let response: ResponseData
}

struct ResponseData: Codable {
    let data: [CCTV]
}

struct CCTV: Codable {
    let cctvname: String
    let cctvurl: String
    let coordx: Double
    let coordy: Double
}

class CctvViewModel: ObservableObject {
    @Published var closestCCTV: CCTV?
    @Published var showVideoPlayer: Bool = false

    func getCCTVUrl(lat: Double, lng: Double) {
        
        closestCCTV = nil
        showVideoPlayer = false
        
        let minX = lng - 1
        let maxX = lng + 1
        let minY = lat - 1
        let maxY = lat + 1
        
        let apiKey = "7165774b4e5f405fadab11205c40be1e"
        let apiUrl = "https://openapi.its.go.kr:9443/cctvInfo?apiKey=\(apiKey)&type=ex&cctvType=2&minX=\(minX)&maxX=\(maxX)&minY=\(minY)&maxY=\(maxY)&getType=json"
        
        AF.request(apiUrl).validate().responseDecodable(of: CCTVResponse.self) { [weak self] response in
            switch response.result {
            case .success(let decodedResponse):
                self?.findClosestCCTV(cctvData: decodedResponse.response.data, lat: lat, lng: lng)
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    private func findClosestCCTV(cctvData: [CCTV], lat: Double, lng: Double) {
        let coordxList = cctvData.map { ($0.coordy, $0.coordx) }
        
        let leftBottom = (lat, lng)
        let distances = coordxList.map { (coordy, coordx) -> Double in
            return sqrt(pow(coordy - leftBottom.0, 2) + pow(coordx - leftBottom.1, 2))
        }
        
        if let minIndex = distances.firstIndex(of: distances.min() ?? Double.infinity) {
            DispatchQueue.main.async {
                self.closestCCTV = cctvData[minIndex]
                self.showVideoPlayer = true
            }
        }
    }
}

struct VideoPlayerView: View {
    let url: String
    @State private var player: AVPlayer?
    
    var body: some View {
        VStack {
            if let videoURL = URL(string: url) {
                VideoPlayer(player: player)
                    .onAppear {
                        DispatchQueue.global().async {
                            let avPlayer = AVPlayer(url: videoURL)
                            DispatchQueue.main.async {
                                player = avPlayer
                                player?.play()
                            }
                        }
                    }
                    .onDisappear {
                        player?.pause()
                        player = nil
                    }
                    .edgesIgnoringSafeArea(.all)
            }
            HStack {
                Text("국토교통부")
                    .foregroundStyle(Color.white)
                    .font(.pretendardMedium(size: 14))
                Text("LIVE")
                    .foregroundStyle(Color.blue)
                    .font(.pretendardMedium(size: 14))
            }
            Text("실제 상황과 30초~1분 정도 차이가 날 수 있습니다.")
                .foregroundStyle(Color.gray)
                .font(.pretendardMedium(size: 10))
        }
    }
}
