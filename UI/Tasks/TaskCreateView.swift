
import SwiftUI
import FirebaseAuth
import UserNotifications
import CoreLocation

struct TaskCreateView: View {
    let groupId: String
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var notes = ""
    @State private var dueDate = Date()
    @State private var hasDueDate = true
    @State private var repeatRule: String = ""
    @State private var imageURLs: [String] = []
    @State private var audioURL: String? = nil
    @State private var coord: CLLocationCoordinate2D? = nil
    @State private var assigned: Set<String> = []

    var body: some View {
        Form {
            Section("Title") { TextField("Title", text: $title) }
            Section("Notes") { TextField("Notes", text: $notes) }
            Section("When") {
                Toggle("Has due date", isOn: $hasDueDate)
                if hasDueDate { DatePicker("When", selection: $dueDate, displayedComponents: [.date, .hourAndMinute]) }
            }
            Section("Repeat") { RecurrencePickerView(rrule: $repeatRule) }
            Section("Assignees") {
                NavigationLink("Select people (\(assigned.count))") {
                    AssignUsersView(groupId: groupId, selected: $assigned)
                }
            }
            Section {
                TaskAttachmentBar(groupId: groupId,
                                  onImages: { imageURLs = $0 },
                                  onAudio: { audioURL = $0 },
                                  onLocation: { coord = $0 })
            }
            Section { Button("Create") { create() }.disabled(title.trimmingCharacters(in: .whitespaces).isEmpty) }
        }
        .navigationTitle("New Task")
        .onAppear { UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {_,_ in } }
    }

    func create() {
        let task = DLTask(groupId: groupId, title: title.trimmingCharacters(in: .whitespaces), notes: notes.isEmpty ? nil : notes, dueDate: hasDueDate ? dueDate : nil, repeatRule: repeatRule.isEmpty ? nil : repeatRule, assignedTo: Array(assigned), isDone: false, imageURLs: imageURLs.isEmpty ? nil : imageURLs, audioURL: audioURL, latitude: coord?.latitude, longitude: coord?.longitude, createdBy: Auth.auth().currentUser?.uid, createdAt: Date(), updatedAt: Date())
        Task {
            try? await TaskService.create(task)
            if let when = task.dueDate { await NotificationsService.schedule(taskId: task.id, title: task.title, notes: task.notes, date: when) }
            dismiss()
        }
    }
}
