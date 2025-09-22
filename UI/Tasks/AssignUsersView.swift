
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AssignUsersView: View {
    let groupId: String
    @Binding var selected: Set<String>
    @State private var members: [String] = []

    var body: some View {
        List(members, id: \.self) { uid in
            HStack {
                Text(uid) // You can resolve display names via UserNameCache if desired
                Spacer()
                if selected.contains(uid) { Image(systemName: "checkmark") }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if selected.contains(uid) { selected.remove(uid) } else { selected.insert(uid) }
            }
        }
        .navigationTitle("Assign")
        .task {
            let snap = try? await Firestore.firestore().collection("groups").document(groupId).getDocument()
            if let arr = snap?.data()?["members"] as? [String] { members = arr }
            if let uid = Auth.auth().currentUser?.uid, !members.contains(uid) { members.append(uid) }
        }
    }
}
