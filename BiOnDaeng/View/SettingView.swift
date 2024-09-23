import SwiftUI
import UserNotifications

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedTime") var selectedTime: String = "08:00"
    @AppStorage("notificationPermission") var notificationPermission: Bool = false
    @AppStorage("bionNotifi") var bionNotifi: Bool = false
    @State var showSheet = false
    @State private var tempSelectedTime: Date = Date()
    @State private var showAlarmAlert = false

    var body: some View {
        VStack {
            HStack {
                Text("알림 설정")
                    .font(.pretendardMedium(size: 14))
                    .padding(.leading, 16)
                
                Spacer()
                
                Button("\(convertTimeToAMPM(selectedTime: selectedTime))") {
                    showSheet = true
                    let components = selectedTime.split(separator: ":").map { Int($0) ?? 0 }
                    tempSelectedTime = Calendar.current.date(from: DateComponents(hour: components[0], minute: components[1])) ?? Date()
                }
                .font(.pretendardMedium(size: 14))
                .foregroundStyle(Color.black)
                .padding(.trailing, 12)
                .sheet(isPresented: $showSheet) {
                    VStack {
                        Image(systemName: "alarm.fill")
                            .resizable()
                            .frame(width: 27.0, height: 27.0)
                            .foregroundColor(Color.black)
                            .padding(.top, 12)
                        
                        Text("알람 설정")
                            .foregroundStyle(Color.black)
                            .font(.pretendardSemiBold(size: 20))
                            .padding(.top, 7)
                        
                        Text("비비가 시간에 맞춰 알려드릴게요!")
                            .foregroundStyle(Color(hex: "A5A5A5")!)
                            .font(.pretendardSemiBold(size: 13))
                            .padding(.top, 15)
                        
                        DatePicker("알람 시간", selection: $tempSelectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .frame(width: 150, height: 150)
                            .padding(.top, 20)
                        
                        Spacer()
                        
                        HStack(spacing: 21) {
                            Button(action: {
                                showSheet = false
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
                                showSheet = false
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH:mm"
                                selectedTime = formatter.string(from: tempSelectedTime)
                            }) {
                                Text("선택완료")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 160, height: 50)
                            .background(Color(hex: "4B81C2"))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.white), lineWidth: 0.5)
                            )
                        }
                        Spacer()
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
                        if newValue {
                            checkNotificationPermission { isAuthorized in
                                if isAuthorized {
                                    notificationPermission = true
                                    bionNotifi = true
                                } else {
                                    showAlarmAlert = true
                                }
                            }
                        } else {
                            notificationPermission = false
                            bionNotifi = false
                        }
                    }
                )) {
                    
                }
                .padding(.trailing, 12)
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
                
                Text("광주광역시 북구")
                    .font(.pretendardMedium(size: 14))
                    .padding(.trailing, 12)
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
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
