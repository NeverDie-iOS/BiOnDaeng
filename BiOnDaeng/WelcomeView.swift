import SwiftUI

struct WelcomeView: View {
    @State var showSheet = false
    @State var selectedTime = Date()
    @State private var navigateToMainView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Bibi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 267)
                
                Text("비온댕에 오신 것을 환영해요!")
                    .font(.pretendardSemiBold(size: 18))
                
                Spacer().frame(height: 20)
                
                Text("저는 비가 오면 우산을 챙겨주는 강아지 비비예요.\n자, 시작할 준비 되셨나요?")
                    .font(.pretendardSemiBold(size: 13))
                    .foregroundStyle(Color(hex: "A5A5A5")!)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: 50)
                
                Button(action: {
                    showSheet = true
                }) {
                    Text("시작하기")
                        .font(.headline)
                        .foregroundColor(Color(hex: "FFFFFF"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "4B81C2"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
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
                        
                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
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
                                navigateToMainView = true
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
            .navigationDestination(isPresented: $navigateToMainView) {
                MainView()
                    .navigationBarBackButtonHidden()
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
