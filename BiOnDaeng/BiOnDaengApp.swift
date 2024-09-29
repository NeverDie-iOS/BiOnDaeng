import SwiftUI
import Firebase
import UserNotifications
import KakaoSDKCommon

@main
struct YourAppName: App {
    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if hasSeenWelcome {
                MainView()
            } else {
                WelcomeView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    @AppStorage("notificationPermission") var notificationPermission: Bool = false
    @AppStorage("bionNotifi") var bionNotifi: Bool = false
    
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
    }
}
