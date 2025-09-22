
import SwiftUI
import FirebaseAuth

struct PollCreateView: View {
    let groupId: String
    @Environment(\.dismiss) var dismiss
    @State private var question = ""
    @State private var options: [String] = ["",""]
    @State private var alertMsg: String? = nil

    var body: some View {
        Form {
            Section("Question") { TextField("Question", text: $question) }
            Section("Options") {
                ForEach(options.indices, id: \.self) { i in TextField("Option \(i+1)", text: $options[i]) }
                Button("Add option") { if options.count < AppConfig.maxPollOptions { options.append("") } }.disabled(options.count >= AppConfig.maxPollOptions)
            }
            Section { Button("Create") { create() }.disabled(!canCreate) }
        }
        .navigationTitle("New Poll")
        .alert("Error", isPresented: .constant(alertMsg != nil), actions: { Button("OK") { alertMsg = nil }}, message: { Text(alertMsg ?? "") })
    }

    var canCreate: Bool {
        let clean = options.map{ $0.trimmingCharacters(in: .whitespaces) }.filter{ !$0.isEmpty }
        let unique = Set(clean)
        return !question.trimmingCharacters(in: .whitespaces).isEmpty && clean.count >= 2 && unique.count == clean.count
    }

    func create() {
        let clean = options.map{ $0.trimmingCharacters(in: .whitespaces) }.filter{ !$0.isEmpty }
        let unique = Array(Set(clean))
        guard unique.count >= 2 else { alertMsg = "Provide at least two unique options."; return }
        let poll = DLPoll(groupId: groupId, question: question.trimmingCharacters(in: .whitespaces), options: unique, createdBy: Auth.auth().currentUser?.uid ?? "unknown")
        Task { try? await PollService.create(poll); dismiss() }
    }
}
