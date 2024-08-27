//
//  WelcomeView.swift
//  BiOnDaeng
//
//  Created by HyunSoo on 8/27/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        Image("Bibi")
        Text("비온댕에 오신 것을 환영해요!")
        Text("저는 비가 오면 우산을 챙겨주는 강아지예요.")
        Text("자, 시작할 준비 되셨나요?")
        Button(action: { }) {
            Text("시작하기")
        }
    }
}

#Preview {
    WelcomeView()
}
