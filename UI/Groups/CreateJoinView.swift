
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreateJoinView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "family"
    @State private var code = ""
    @State private var alertMsg: String? = nil
    @StateObject private var iap = IAPService()

    var body: some View {
        Form {
            Section("Create group") {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) { Text("Family").tag("family"); Text("Work").tag("work"); Text("Friends").tag("friends") }
                Button("Create") { Task { await create() } }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            Section("Join by code") {
                TextField("Invite code", text: $code).textInputAutocapitalization(.characters)
                Button("Create/Join") { Task { await join() } }.disabled(code.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            if !iap.hasPremium() { Text("Free plan: up to \(AppConfig.freeMaxGroups) groups").font(.footnote).foregroundStyle(.secondary) }
        }
        .navigationTitle("Create/Join")
        .alert("Error", isPresented: .constant(alertMsg != nil), actions: { Button("OK") { alertMsg = nil } }, message: { Text(alertMsg ?? "") })
        .task { await iap.load() }
    }

    func create() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if !iap.hasPremium() {
            let snap = try? await Firestore.firestore().collection("groups").whereField("members", arrayContains: uid).getDocuments()
            let count = snap?.documents.count ?? 0
            if count >= AppConfig.freeMaxGroups { alertMsg = "Free plan limit reached. Buy Premium to create more groups."; return }
        }
        let doc = Firestore.firestore().collection("groups").document() // Firestore ID avoids collisions
        do {
            try await doc.setData([ "id": doc.documentID, "name": name.isEmpty ? "Group" : name, "type": type, "members": [uid], "inviteCode": String(UUID().uuidString.prefix(8)).uppercased(), "owners": [uid] ])
            dismiss()
        } catch { alertMsg = error.localizedDescription }
    }

    func join() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let q = Firestore.firestore().collection("groups").whereField("inviteCode", isEqualTo: code.uppercased())
            let snap = try await q.getDocuments()
            guard let doc = snap.documents.first else { alertMsg = "Invite code not found"; return }
            try await doc.reference.updateData(["members": FieldValue.arrayUnion([uid])])
            dismiss()
        } catch { alertMsg = error.localizedDescription }
    }
}
