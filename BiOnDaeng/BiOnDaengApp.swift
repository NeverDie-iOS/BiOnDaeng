import SwiftUI
import Firebase
import UserNotifications
import KakaoSDKCommon

@main
struct BiOnDaengApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("uuid") private var uuid: String = ""
    
    init() {
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoAppKey)
        if uuid.isEmpty {
            uuid = UUID().uuidString
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    @AppStorage("notificationPermission") var notificationPermission: Bool = false
    @AppStorage("bionNotifi") var bionNotifi: Bool = false
    @AppStorage("fcmToken") private var fcmToken: String = ""
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        requestNotificationAuthorization()
        
        Messaging.messaging().delegate = self
        return true
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error)")
                return
            }
            self.notificationPermission = granted
            self.bionNotifi = granted
        }
        
        center.delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("등록 토큰 수신: \(String(describing: fcmToken))")
        
        guard let fcmToken = fcmToken else { return }
            self.fcmToken = fcmToken
    }
}

extension Bundle {
    var gisangAuth: String {
        guard let file = self.path(forResource: "MyPrivacyInfo", ofType: "plist") else { fatalError("MyPrivacyInfo.plist 파일이 없습니다.") }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 형식 에러") }
        guard let key = resource["gisangAuth"] as? String else { fatalError("키값 에러")}
        return key
    }
    
    var kakaoAppKey: String {
        guard let file = self.path(forResource: "MyPrivacyInfo", ofType: "plist") else { fatalError("MyPrivacyInfo.plist 파일이 없습니다.") }
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 형식 에러") }
        guard let key = resource["kakaoAppKey"] as? String else { fatalError("키값 에러")}
        return key
    }
}
