import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Image("Bibi")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 267)
        
        Text("비온댕에 오신 것을 환영해요!")
            .font(.pretendardSemiBold18)
        
        Spacer().frame(height: 20)
        
        Text("저는 비가 오면 우산을 챙겨주는 강아지예요.\n자, 시작할 준비 되셨나요?")
            .font(.pretendardSemiBold13)
            .foregroundStyle(Color(hex: "A5A5A5")!)
            .multilineTextAlignment(.center)
        
        Spacer().frame(height: 50)
        
        Button(action: { }) {
            Text("시작하기")
                .font(.headline)
                .foregroundColor(Color(hex: "FFFFFF"))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(hex: "4B81C2"))
                .cornerRadius(10)
        }
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    WelcomeView()
        .previewDevice("iPhone SE (2nd generation)")
        .previewDisplayName("iPhone SE")
}
