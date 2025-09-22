
import SwiftUI
import FirebaseCore
import FirebaseAuth
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        PushService.registerForPush()
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions { [.banner, .sound] }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = PushService.apnsTokenToString(deviceToken)
        Task { await UserService.updatePushToken(token) }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs register failed", error)
    }
}

@main
struct DaylineApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() { FirebaseApp.configure() }
    var body: some Scene { WindowGroup { RootView() } }
}

struct RootView: View {
    @State private var handle: AuthStateDidChangeListenerHandle?
    @State private var user: User? = Auth.auth().currentUser
    var body: some View {
        Group { if user == nil { AuthView() } else { NavigationStack { GroupListView() } } }
        .onAppear {
            handle = Auth.auth().addStateDidChangeListener { _, u in
                self.user = u
                Task { await UserService.ensureUserDoc() }
            }
        }
        .onDisappear { if let h = handle { Auth.auth().removeStateDidChangeListener(h) } }
    }
}
