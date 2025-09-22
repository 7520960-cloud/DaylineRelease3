
import Foundation
struct DLTask: Codable, Identifiable {
    var id: String = UUID().uuidString
    var groupId: String
    var title: String
    var notes: String?
    var dueDate: Date?
    var repeatRule: String?
    var assignedTo: [String] = []
    var isDone: Bool = false
    var imageURLs: [String]? = nil
    var audioURL: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var createdBy: String?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}
