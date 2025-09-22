
import Foundation
struct DLGroup: Codable, Identifiable {
    var id: String
    var name: String
    var type: String? = nil
    var members: [String]
    var inviteCode: String
    var owners: [String]
}
