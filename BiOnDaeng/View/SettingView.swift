import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Text("알림 설정")
                    .font(.pretendardMedium(size: 14))
                    .padding(.leading, 16)
                
                Spacer()
                
                Button("오전 08:00") {
                    
                }
                .font(.pretendardMedium(size: 14))
                .foregroundStyle(Color.black)
                .padding(.trailing, 12)
            }
            .frame(width: 333 * UIScreen.main.bounds.width / 393, height: 67 * UIScreen.main.bounds.height / 852)
            .background(Color(hex: "FFFCF1"))
            .overlay( RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "FFE58C")!, lineWidth: 2)
            )
            .padding(.top, 27)
        
            
            HStack {
                Text("비 알림")
                    .font(.pretendardMedium(size: 14))
                    .padding(.leading, 16)
                Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                    
                }
                .padding(.trailing, 12)
            }
            .frame(width: 333 * UIScreen.main.bounds.width / 393, height: 67 * UIScreen.main.bounds.height / 852)
            .background(Color(hex: "FFFCF1"))
            .overlay( RoundedRectangle(cornerRadius: 16)
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
            .overlay( RoundedRectangle(cornerRadius: 16)
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
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
