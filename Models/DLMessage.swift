
import Foundation
struct DLMessage: Codable, Identifiable {
    var id: String
    var senderId: String
    var senderName: String
    var text: String
    var timestamp: Date
    var deliveredTo: [String] = []
    var readBy: [String] = []
    var imageURLs: [String]? = nil
    var audioURL: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
}
