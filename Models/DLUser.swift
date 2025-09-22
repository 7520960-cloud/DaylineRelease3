
import Foundation
struct DLUser: Codable, Identifiable {
    var id: String
    var displayName: String?
    var email: String?
    var apnsToken: String?
}
