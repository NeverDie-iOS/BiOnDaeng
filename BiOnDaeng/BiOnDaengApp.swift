import SwiftUI
import Firebase
import UserNotifications
import KakaoSDKCommon

@main
struct BiOnDaengApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        KakaoSDK.initSDK(appKey: "d5db3d55c891ebc5cf8b961bb5ca0131")
    }
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    @AppStorage("notificationPermission") var notificationPermission: Bool = false
    @AppStorage("bionNotifi") var bionNotifi: Bool = false
    
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
    }
}
