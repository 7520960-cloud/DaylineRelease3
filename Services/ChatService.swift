
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatPage {
    let messages: [DLMessage]
    let last: DocumentSnapshot?
}

enum ChatService {
    static func loadInitial(groupId: String, pageSize: Int = 50) async -> ChatPage {
        let ref = Firestore.firestore().collection("groups").document(groupId).collection("chat").order(by: "timestamp", descending: true).limit(to: pageSize)
        let snap = try? await ref.getDocuments()
        let docs = snap?.documents ?? []
        let last = docs.last
        let arr = docs.compactMap { try? $0.data(as: DLMessage.self) }.reversed()
        return ChatPage(messages: Array(arr), last: last)
    }
    static func loadMore(groupId: String, after: DocumentSnapshot?, pageSize: Int = 50, completion: @escaping (ChatPage)->Void) {
        guard let after = after else { completion(ChatPage(messages: [], last: nil)); return }
        let ref = Firestore.firestore().collection("groups").document(groupId).collection("chat").order(by: "timestamp", descending: true).start(afterDocument: after).limit(to: pageSize)
        ref.getDocuments { snap, _ in
            let docs = snap?.documents ?? []
            let last = docs.last
            let arr = docs.compactMap { try? $0.data(as: DLMessage.self) }.reversed()
            completion(ChatPage(messages: Array(arr), last: last))
        }
    }
}
