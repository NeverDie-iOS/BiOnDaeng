[![Swift 6.0](https://img.shields.io/badge/swift-6.0-ED523F.svg?style=flat)](https://swift.org/download/) [![Xcode 16.0](https://img.shields.io/badge/Xcode-16.0-ED523F.svg?style=flat&color=blue)](https://swift.org/download/) [![Platform iOS](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://developer.apple.com/ios/) [![Email](https://img.shields.io/badge/contact-mm083434%40naver.com-03C75A)](mailto:mm083434@naver.com)

> 비온댕 - 외출 전 비가 오면 알려주는 댕댕이
> 
> 🎉 App Store 날씨 부문 인기 차트 14위 달성

![비온댕](https://github.com/user-attachments/assets/b1023800-3819-499c-b84d-e8df1ff17de0)

&nbsp;
## Download App <br> <a href="https://apps.apple.com/us/app/%EB%B9%84%EC%98%A8%EB%8C%95/id6736566563" style="vertical-align: -5px;"><img src="https://img.shields.io/badge/App Store-0D96F6?style=for-the-badge&logo=App%20Store&logoColor=white" alt="Download on the App Store"></a>


<img src="https://github.com/user-attachments/assets/ca5478a1-e27d-4a80-bf38-05806f43e84f" alt="QR Code" width="200">

&nbsp;
## 🌧️ 프로젝트 소개

`비온댕`은 강수 알림 서비스를 제공하는 iOS 애플리케이션입니다.

비 소식이 있는 날에 강아지가 알림을 보내, 외출 전 우산을 챙길 수 있도록 도와줍니다.🐶

&nbsp;
## ✨ 주요 기능

### 📱 강수 알림 서비스
- 외출 전 우산 챙김 리마인더
- 초단기 예보 기반의 높은 정확도
- 강수량에 따른 맞춤형 정보 제공

### 🎥 CCTV 날씨 확인
- `실시간 도로 CCTV` 영상 제공
- 현재 하늘 상태 실시간 모니터링

### 🌤️ 일기 예보
- `오늘`/`내일`/`모레` 날씨 예보 제공
- 시간대별 강수 확률 정보
- 개황 및 습도 정보

### 📤 날씨 공유
- `카카오톡`/`인스타그램` 등 SNS를 통한 날씨 정보 공유
- iPhone 기본 공유(Share Extension)
- 실시간 날씨 상태 공유

> "비온댕과 함께라면, 비 오는 날도 걱정 없어!" 🌧️🐶

&nbsp;
## ☔️ 앱 실행 화면

> 🌓 앱 실행 시 초기화면입니다.

    - 앱 첫 실행 시: Welcome View
    - 알림/지역 설정 후: 홈 화면

![splash](https://github.com/user-attachments/assets/93a94120-5086-4f80-9640-a14428e8d6f4)

&nbsp;

> ✅ `알림 시간`과 `지역`을 설정합니다.

    - 초기 설정 후 앱 실행 시 더 이상 Welcome View가 표시되지 않습니다.

![setting](https://github.com/user-attachments/assets/be9e362d-0b26-45d5-a4de-8f273d46e17d)

&nbsp;

> 📍 현재 위치의 행정구역으로 지역을 설정합니다.

![local](https://github.com/user-attachments/assets/fcbf3260-3561-498c-8b52-8eea9011db97)

&nbsp;

> 🌦️ 날씨 예보 확인

### 📱 Home
- `현재`/`최고`/`최저` 기온 표시
- 강수 확률 정보 제공
- `초단기 실황` 날씨 정보

### 🔍 Detail
- 스와이프로 상세 날씨 정보 확인
- `강수량`, `습도` 등 세부 기상 정보
- `내일`/`모레` 날씨 예보 제공
- 강수 형태별 이해하기 쉬운 상세 설명

![detailView](https://github.com/user-attachments/assets/a868d932-0137-449e-b307-a5c6c7de1b31)

&nbsp;

> 📢 Push Message(예시)

     - 지정한 시간 +6H 이내에 비 예보가 있다면 알림을 받습니다.
     - (비가 내리는 날에만 알림이 와요!)
<img src="https://github.com/user-attachments/assets/18204049-f417-4154-81b5-9496c2da5adb" width="275" height="480">

&nbsp;

> 🎥 실시간 CCTV 영상

    - 설정한 지역에서 가장 가까운 CCTV 영상을 재생합니다.

![cctv](https://github.com/user-attachments/assets/54056e8f-d5bc-4ae1-8f2c-b8d68c6d71a2)

&nbsp;

> 🌂 날씨 정보 공유

    - 비가 오는 날 지인과 친구들에게 우산을 챙기도록 알려주세요.
    - KakaoTalk / Instagram 스토리 / iPhone 기본 공유 가능

![share_kakao](https://github.com/user-attachments/assets/d6f237c4-4769-4164-b331-30d2c3f098bc)

![share_insta](https://github.com/user-attachments/assets/27fa6d6c-5c06-42aa-8073-63f7abb81fac)

![share](https://github.com/user-attachments/assets/44f82e3a-3f31-489f-b6e6-39ce8a214513)

&nbsp;

> ⚙️ 설정 화면

    - '알림 시간 / 알림 허용 / 지역'을 설정할 수 있어요.

![setting](https://github.com/user-attachments/assets/238ee861-7cf4-46dc-af92-ea70f947ce39)

&nbsp;
## 🛠 Tech Stack

### 📱 iOS
- `SwiftUI`
- `Combine`
- `CoreLocation`
- `UserNotifications`
- `AVKit`

### 🎨 Design
- `Figma`
- `Lottie`

### 🔗 Network
- `REST API`
- `Alamofire`

### ⚙️ Backend
- `Strapi DB`
- `Node.js`

### ☁️ Cloud Services
- `Naver Cloud Platform (NCP)`
- `Firebase Cloud Messaging (FCM)`

### 🔧 Tools
- `GitHub`
- `Xcode`
- `Postman`
- `Visual Studio Code`


&nbsp;
## 🙏 Thanks to

### 🌤️ 기상청 API
- 초단기 실황 조회
- 초단기 예보 조회
- 단기 예보 조회

### 📍 Kakao Developers
- Reverse Geocoding API
- KakaoTalk Share API

### 🎥 국토교통부_ITS 국가 교통정보센터
- 실시간 도로 CCTV 영상 정보 API

### ☁️ Cloud Services
- NCP(Naver Cloud Platform)

### 📱 Push Notification
- Firebase Cloud Messaging (FCM)

### 👩🏻‍🎨 Designer
- 유가경_전남대학교 디자인학과 3학년

&nbsp;
## Releases <br>

> `v1.0.0` 2024.08.27 - 2024.10.05

> `v1.0.1` 2024.10.10
- 날씨 데이터 처리 방법 개선

> `v1.0.2` 2024.10.13
- UI 수정

> `v1.0.3` 2024.10.14
- 버그 fix

> `v1.1.0` 2024.10.19
- 공유 기능 추가

&nbsp;
| Emoji | Description | 
|------|---|
| 🎨 | asset 이미지, 폰트 등 필요한 파일 추가 |
| 🟡 | 파일 추가 |
| 🗑️ | 파일 삭제 |
| 💩 | 간단한 코드 변경 및 잡일 |
| ⚡️ | 기능 추가 / 뷰 구성 완료
| 🔧 | 버그 fix



<br>

<개인정보 처리 방침>

본 개인정보 처리 방침은 [비온댕] (이하 “본 앱”)이 사용자로부터 개인정보를 수집, 사용, 저장하지 않음을 설명합니다.
1. 개인정보 수집

본 앱은 사용자로부터 어떠한 개인정보도 수집하지 않습니다.

2. 개인정보 사용

본 앱은 사용자의 개인정보를 사용하지 않습니다.

3. 제3자 제공

본 앱은 개인정보를 제3자에게 제공하지 않습니다.

4. 개인정보 보호

본 앱은 개인정보를 수집하지 않으므로, 별도의 개인정보 보호 조치는 필요하지 않습니다.

5. 사용자의 권리

본 앱은 개인정보를 수집하지 않으므로, 사용자는 개인정보에 대한 접근, 수정, 삭제 요청을 할 필요가 없습니다.

6. 변경 사항

본 방침이 변경될 경우, 앱 내 공지로 알려드릴 것입니다.

7. 연락처
   
본 앱에 대한 문의는 [mm083434@naver.com]로 연락 주시기 바랍니다.
