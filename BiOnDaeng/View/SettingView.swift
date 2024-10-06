import SwiftUI
import UserNotifications
import Alamofire

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedTime") var selectedTime: String = "08:00"
    @AppStorage("notificationPermission") var notificationPermission: Bool = false
    @AppStorage("bionNotifi") var bionNotifi: Bool = false
    @State var showAlarmSheet = false
    @State private var tempSelectedTime: Date = Date()
    @State private var showAlarmAlert = false
    @AppStorage("myLocation") var myLocation: String = "설정"
    @State var showLocationSheet = false
    @AppStorage("id") private var id: Int = 0
    @StateObject private var networkMonitor = NetworkMonitor()
    @AppStorage("uuid") private var uuid: String = ""
    @State private var showAlert = false // 네트워크 연결 불안정
    
    var body: some View {
        VStack {
            HStack {
                Text("알림 설정")
                    .font(.pretendardMedium(size: 14))
                    .padding(.leading, 16)
                
                Spacer()
                
                Button("\(convertTimeToAMPM(selectedTime: selectedTime))") {
                    showAlarmSheet = true
                    let components = selectedTime.split(separator: ":").map { Int($0) ?? 0 }
                    tempSelectedTime = Calendar.current.date(from: DateComponents(hour: components[0], minute: components[1])) ?? Date()
                }
                .font(.pretendardMedium(size: 14))
                .foregroundStyle(Color.black)
                .padding(.trailing, 12)
                .sheet(isPresented: $showAlarmSheet) {
                    VStack {
                        Image("Alarm")
                            .resizable()
                            .frame(width: 27.0, height: 27.0)
                            .foregroundColor(Color.black)
                            .padding(.top, 12)
                        
                        Text("알림 설정")
                            .foregroundStyle(Color.black)
                            .font(.pretendardSemiBold(size: 20))
                        
                        Text("☔️앞으로 6시간 안에 비가 오면☔️\n비비가 선택한 시간에 알려드릴게요🐶🐾")
                            .foregroundStyle(Color(hex: "A5A5A5")!)
                            .font(.pretendardSemiBold(size: 15))
                            .padding(.top, 4)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .kerning(1)
                        
                        DatePicker("알람 시간", selection: $tempSelectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .frame(width: 150, height: 150)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        HStack(spacing: 21) {
                            Button(action: {
                                showAlarmSheet = false
                            }) {
                                Text("취소")
                                    .foregroundStyle(.black)
                            }
                            .frame(width: 160, height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.black), lineWidth: 0.5)
                            )
                            
                            Button(action: {
                                if networkMonitor.isConnected {
                                    showAlarmSheet = false
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "HH:mm"
                                    selectedTime = formatter.string(from: tempSelectedTime)
                                    fetchRecordID(using: uuid) {
                                        updateBaseTimeInDatabase()
                                    }
                                } else {
                                    showAlert = true
                                }
                            }) {
                                Text("선택완료")
                                    .foregroundStyle(.white)
                                    .font(.pretendardSemiBold(size: 18))
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(width: 160, height: 50)
                            .background(Color(hex: "006FC2"))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.white), lineWidth: 0.5)
                            )
                        }
                        Spacer()
                    }
                    .alert("네트워크 연결이 불안정합니다. 다시 시도해주세요", isPresented: $showAlert) {
                        Button("확인", role: .cancel) {}
                    }
                    .presentationDetents([.height(400)])
                }
            }
            .frame(width: 333 * UIScreen.main.bounds.width / 393, height: 67 * UIScreen.main.bounds.height / 852)
            .background(Color(hex: "FFFCF1"))
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "FFE58C")!, lineWidth: 2)
            )
            .padding(.top, 27)
        
            HStack {
                Text("비 알림")
                    .font(.pretendardMedium(size: 14))
                    .padding(.leading, 16)
                
                Toggle(isOn: Binding(
                        get: {
                            bionNotifi
                        },
                        set: { newValue in
                            if networkMonitor.isConnected {
                                fetchRecordID(using: uuid) {
                                    updateAlarmPermissionInDatabase(isEnabled: newValue)

                                    if newValue {
                                        checkNotificationPermission { isAuthorized in
                                            if isAuthorized {
                                                notificationPermission = true
                                                bionNotifi = true
                                            } else {
                                                showAlarmAlert = true
                                                bionNotifi = false
                                            }
                                        }
                                    } else {
                                        notificationPermission = false
                                        bionNotifi = false
                                    }
                                }
                            } else {
                                showAlert = true
                            }
                        }
                    )) {
                    
                }
                .padding(.trailing, 12)
                .alert("네트워크 연결이 불안정합니다. 다시 시도해주세요", isPresented: $showAlert) {
                    Button("확인", role: .cancel) {}
                }
                .alert(isPresented: $showAlarmAlert) {
                    Alert(
                        title: Text("알림 설정 필요"),
                        message: Text("알림을 활성화하려면 알림 설정을 허용해야 합니다."),
                        primaryButton: .default(Text("확인")) {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        },
                        secondaryButton: .cancel(Text("취소")) {
                            notificationPermission = false
                            bionNotifi = false
                        }
                    )
                }
            }
            .frame(width: 333 * UIScreen.main.bounds.width / 393, height: 67 * UIScreen.main.bounds.height / 852)
            .background(Color(hex: "FFFCF1"))
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "FFE58C")!, lineWidth: 2)
            )
            .padding(.top, 13)
            
            HStack {
                Text("지역 설정")
                    .font(.pretendardMedium(size: 14))
                    .padding(.leading, 16)
                
                Spacer()
                
                Button(action: {
                    showLocationSheet = true
                }) {
                    Text("\(myLocation)")
                        .foregroundColor(myLocation == "설정" ? .blue : .black)
                        .font(.pretendardMedium(size: 14))
                        .padding()
                }
                .fullScreenCover(isPresented: $showLocationSheet) {
                    LocationSearchView(myLocation: $myLocation)
                }
            }
            .frame(width: 333 * UIScreen.main.bounds.width / 393, height: 67 * UIScreen.main.bounds.height / 852)
            .background(Color(hex: "FFFCF1"))
            .overlay(RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "FFE58C")!, lineWidth: 2)
            )
            .padding(.top, 13)
            
            Spacer()
        }
        .navigationTitle("설정")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image("Back")
                .resizable()
                .frame(width: 26, height: 25)
        })
        .onAppear {
            checkNotificationPermission { isAuthorized in
                if isAuthorized {
                    notificationPermission = true
                } else {
                    notificationPermission = false
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
                checkNotificationPermission { isAuthorized in
                    notificationPermission = isAuthorized
                    bionNotifi = isAuthorized
                }
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    func checkNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func convertTimeToAMPM(selectedTime: String) -> String {
        let components = selectedTime.split(separator: ":").map { Int($0) }
        guard let hour = components[0], let minute = components[1] else {
            return selectedTime
        }
        
        let period = hour < 12 ? "오전" : "오후"
        let adjustedHour = hour % 12 == 0 ? 12 : hour % 12
        return String(format: "%@ %02d:%02d", period, adjustedHour, minute)
    }
    
    func getBaseTime(_ selectedTime: String) -> String {
        let components = selectedTime.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return "Invalid time"
        }
        
        if hour == 0 && minute <= 45 {
            return "2330"
        } else if minute <= 45 {
            let newHour = hour - 1
            return String(format: "%02d30", newHour)
        } else {
            return String(format: "%02d30", hour)
        }
    }
    
    func isYesterday(_ selectedTime: String) -> Bool {
        let components = selectedTime.split(separator: ":")
        let hour = Int(components[0])!
        let minute = Int(components[1])!
        
        if hour == 0 && minute <= 45 {
            return true
        } else {
            return false
        }
    }
    
    func updateBaseTimeInDatabase() {
        let url = "http://211.188.54.174:1337/alarms/\(id)"
        print("updateBaseTimeInDatabase id:\(id)")
        let parameters: [String: Any] = [
            "base_time": getBaseTime(selectedTime),
            "isYesterday": isYesterday(selectedTime),
            "selectedTime": selectedTime
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("BaseTime/isYesterday 업데이트.")
                case .failure(let error):
                    print("BaseTime/isYesterday 업데이트 실패: \(error)")
                    if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("서버 응답: \(errorMessage)")
                    }
                }
            }
    }
    
    func fetchRecordID(using uuid: String, completion: @escaping () -> Void) {
        let url = "http://211.188.54.174:1337/alarms?uuid=\(uuid)"
        
        AF.request(url)
            .validate()
            .responseDecodable(of: [Record].self) { response in
                switch response.result {
                case .success(let records):
                    if let firstRecord = records.first {
                        id = firstRecord.id
                        print("id = \(firstRecord.id)")
                        completion()
                    } else {
                        print("레코드를 찾을 수 없습니다.")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    func updateAlarmPermissionInDatabase(isEnabled: Bool) {
            let url = "http://211.188.54.174:1337/alarms/\(id)"
            let parameters: [String: Any] = [
                "alarmPermission": isEnabled
            ]
            
            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        print("비 알림 상태 업데이트 완료.")
                    case .failure(let error):
                        print("비 알림 상태 업데이트 실패: \(error)")
                        if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                            print("서버 응답: \(errorMessage)")
                        }
                    }
                }
        }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
