import SwiftUI
import Alamofire

struct LocationSearchView: View {
    @State var searchText: String = ""
    @State private var locations: [String: (String, String, String, String)] = loadCSV()
    @Binding var myLocation: String
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("nx") var nx: String = "0"
    @AppStorage("ny") var ny: String = "0"
    @AppStorage("longitude") var longitude: String = "0"
    @AppStorage("latitude") var latitude: String = "0"
    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
    @StateObject private var networkMonitor = NetworkMonitor()
    @AppStorage("uuid") private var uuid: String = ""
    @AppStorage("fcmToken") private var fcmToken: String = ""
    @AppStorage("baseTime") private var baseTime: String = ""
    @AppStorage("isYesterday") private var isYesterday: Bool = false
    @AppStorage("alarmPermission") private var alarmPermission: Bool = false
    @State private var showAlert = false // 네트워크 연결 불안정
    @AppStorage("id") private var id: Int = 0
    
    var filteredLocations: [String] {
        if searchText.isEmpty || searchText == " " {
            return []
        } else {
            return locations.keys.filter { $0.contains(searchText) }.sorted { $0.count < $1.count }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("Search")
                    .resizable()
                    .frame(width: 19, height: 19)
                    .padding(.leading, 7)
                    .padding(.vertical, 6)
                
                TextField("지역(구/동)을 입력하세요.", text: $searchText)
                    .font(.pretendardMedium(size: 10))
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("취소")
                        .foregroundStyle(Color.black)
                        .padding(.trailing, 10)
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "E0E0E0")!, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            List(filteredLocations, id: \.self) { location in
                Button(action: {
                    if networkMonitor.isConnected {
                        fetchRecordID(using: uuid)
                        myLocation = location
                        nx = locations[location]!.0
                        ny = locations[location]!.1
                        longitude = locations[location]!.2
                        latitude = locations[location]!.3
                        
                        alarmPermission = checkNotificationPermissionSync()
                        saveLocationToDatabase()
                        hasSeenWelcome = true
                        
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("\(location)")
                }
            }
            .listStyle(.inset)
            .padding(0)
        }
        .alert("네트워크 연결이 불안정합니다. 다시 시도해주세요", isPresented: $showAlert) {
            Button("확인", role: .cancel) {}
        }
        .padding(0)
    }
    
    func saveLocationToDatabase() {
        checkUUIDExists(uuid: uuid) { exists in
            if exists {
                updateLocationInDatabase()
            } else {
                addLocationToDatabase()
            }
        }
    }

    func checkUUIDExists(uuid: String, completion: @escaping (Bool) -> Void) {
        let url = "http://211.188.54.174:1337/alarms?uuid=\(uuid)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: [Alarm].self) { response in
                switch response.result {
                case .success(let alarms):
                    if alarms.isEmpty {
                        print("UUID가 존재하지 않습니다.")
                        completion(false)
                    } else {
                        print("UUID가 존재합니다.")
                        completion(true)
                    }
                    
                case .failure(let error):
                    print("요청 실패: \(error.localizedDescription)")
                    completion(false)
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

    func addLocationToDatabase() {
        let url = "http://211.188.54.174:1337/alarms" // 추가 URL
        let parameters: [String: Any] = [
            "uuid": uuid,
            "nx": nx,
            "ny": ny,
            "base_time": baseTime,
            "isYesterday": isYesterday,
            "alarmPermission": alarmPermission,
            "fcmToken": fcmToken
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("위치 정보가 성공적으로 저장되었습니다.")
                case .failure(let error):
                    print("위치 정보 저장 실패: \(error)")
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 응답: \(errorMessage)")
                    }
                }
            }
    }
    
    func checkNotificationPermissionSync() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var isAuthorized = false

        UNUserNotificationCenter.current().getNotificationSettings { settings in
            isAuthorized = settings.authorizationStatus == .authorized
            semaphore.signal()
        }

        semaphore.wait()
        return isAuthorized
    }
    
    func fetchRecordID(using uuid: String) {
        let url = "http://211.188.54.174:1337/alarms?uuid=\(uuid)"
        
        AF.request(url)
               .validate()
               .responseDecodable(of: [Record].self) { response in
                   switch response.result {
                   case .success(let records):
                       if let firstRecord = records.first {
                           id = firstRecord.id
                           print(firstRecord.id)
                       } else {
                       }
                   case .failure(let error):
                       print("Error: \(error)")
                   }
               }
    }
}

struct Record: Codable {
    let id: Int
    let uuid: String
}

struct Alarm: Decodable {
    let uuid: String
}
