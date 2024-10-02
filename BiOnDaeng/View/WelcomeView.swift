import SwiftUI

struct WelcomeView: View {
    @State var showSheet = false // 알람 시간 설정 sheet
    @State var showLocationSheet = false // 지역 설정 sheet
    @AppStorage("myLocation") var myLocation: String = ""
    @AppStorage("selectedTime") var selectedTime: String = "08:00"
    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
    @State private var navigateToMainView = false
    @StateObject private var networkMonitor = NetworkMonitor()
    @AppStorage("uuid") private var uuid: String = ""
    @AppStorage("fcmToken") private var fcmToken: String = ""
    @State private var showAlert = false // 네트워크 연결 불안정
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Bibi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 267)
                    .padding(.trailing, 40)
                
                Text("비온댕에 오신 것을 환영해요!")
                    .font(.pretendardSemiBold(size: 18))
                    .padding(.leading, 20)
                
                Spacer().frame(height: 20)
                
                Text("저는 비가 오면 우산을 챙겨주는 강아지 비비예요.\n자, 시작할 준비 되셨나요?")
                    .font(.pretendardSemiBold(size: 13))
                    .foregroundStyle(Color(hex: "A5A5A5")!)
                    .multilineTextAlignment(.center)
                    .padding(.leading, 20)
                
                Spacer().frame(height: 50)
                
                Button(action: {
                    if networkMonitor.isConnected && uuid != "" && fcmToken != "" {
                        showSheet = true
                    } else {
                        showAlert = true
                    }
                }) {
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "006FC2"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .sheet(isPresented: $showSheet) {
                    VStack {
                        Image(systemName: "alarm.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFit()
                            .foregroundColor(Color.black)
                            .padding(.top, 12)
                        
                        Text("알람 설정")
                            .foregroundStyle(Color.black)
                            .font(.pretendardSemiBold(size: 20))
                            .padding(.top, 7)
                        
                        Text("비비가 시간에 맞춰 알려드릴게요!")
                            .foregroundStyle(Color(hex: "A5A5A5")!)
                            .font(.pretendardSemiBold(size: 13))
                            .padding(.top, 6)
                        
                        DatePicker("알람 시간", selection: Binding(
                            get: {
                                let components = selectedTime.split(separator: ":").map { Int($0) ?? 0 }
                                return Calendar.current.date(from: DateComponents(hour: components[0], minute: components[1]))!
                            },
                            set: { newTime in
                                let formatter = DateFormatter()
                                formatter.dateFormat = "HH:mm"
                                selectedTime = formatter.string(from: newTime)
                            }
                        ), displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .frame(width: 150, height: 150)
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        HStack(spacing: 21) {
                            Button(action: {
                                showSheet = false
                            }) {
                                Text("취소")
                                    .foregroundStyle(Color.black)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(width: 169, height: 52)
                            .background(Color(hex: "F8F8F7")!)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.black), lineWidth: 0.5)
                            )
                            
                            Button(action: {
                                if networkMonitor.isConnected {
                                    showSheet = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        showLocationSheet = true
                                    }
                                } else {
                                    showAlert = true
                                }
                                
                            }) {
                                Text("선택완료")
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(width: 169, height: 52)
                            .background(Color(hex: "006FC2"))
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
                .fullScreenCover(isPresented: $showLocationSheet) {
                    LocationSearchView(myLocation: $myLocation)
                }
            }
            .onChange(of: myLocation) { newValue in
                if !newValue.isEmpty {
                    navigateToMainView = true
                }
            }
            .navigationDestination(isPresented: $navigateToMainView) {
                MainView()
                    .navigationBarBackButtonHidden()
            }
            .alert("네트워크 연결이 불안정합니다. 다시 시도해주세요", isPresented: $showAlert) {
                Button("확인", role: .cancel) {}
                        }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
                .previewDisplayName("iPhone 15 Pro")
            WelcomeView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
        }
    }
}
