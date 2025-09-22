
import FirebaseAuth
import FirebaseFirestore

enum UserService {
    static func ensureUserDoc() async {
        guard let u = Auth.auth().currentUser else { return }
        let ref = Firestore.firestore().collection("users").document(u.uid)
        do {
            let snap = try await ref.getDocument()
            if !snap.exists {
                try await ref.setData([
                    "id": u.uid,
                    "email": u.email ?? "",
                    "displayName": u.displayName ?? "User",
                    "createdAt": Date()
                ])
            }
        } catch { print("ensureUserDoc error", error) }
    }

    static func updateDisplayName(_ name: String) async {
        guard let u = Auth.auth().currentUser else { return }
        let ref = Firestore.firestore().collection("users").document(u.uid)
        try? await ref.setData(["displayName": name], merge: true)
    }

    static func updatePushToken(_ token: String) async {
        guard let u = Auth.auth().currentUser else { return }
        let ref = Firestore.firestore().collection("users").document(u.uid)
        try? await ref.setData(["apnsToken": token, "apnsTokenUpdatedAt": Date()], merge: true)
    }
}
