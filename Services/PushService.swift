
import UIKit
import UserNotifications

enum PushService {
    static func registerForPush() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { _, _ in
            DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
        }
    }

    static func apnsTokenToString(_ deviceToken: Data) -> String {
        return deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    }
}
