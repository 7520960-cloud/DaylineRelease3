
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

enum PollService {
    static func create(_ poll: DLPoll) async throws {
        try Firestore.firestore().collection("groups").document(poll.groupId).collection("polls").document(poll.id).setData(from: poll)
    }

    static func vote(groupId: String, pollId: String, option: Int) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore().collection("groups").document(groupId).collection("polls").document(pollId)
        try await Firestore.firestore().runTransaction { transaction, _ in
            let snapshot = try transaction.getDocument(ref)
            var data = snapshot.data() ?? [:]
            var votes = data["votes"] as? [String:Int] ?? [:]
            if votes[uid] != nil {
                // already voted; do not allow change
                return nil
            }
            votes[uid] = option
            transaction.updateData(["votes": votes], forDocument: ref)
            return nil
        }
    }
}
