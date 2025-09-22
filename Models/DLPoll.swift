
import Foundation
struct DLPoll: Codable, Identifiable {
    var id: String = UUID().uuidString
    var groupId: String
    var question: String
    var options: [String]
    var votes: [String:Int] = [:]
    var createdBy: String
    var createdAt: Date = Date()
}
