
import FirebaseFirestore
import FirebaseFirestoreSwift

enum TaskService {
    static func create(_ task: DLTask) async throws {
        let ref = Firestore.firestore().collection("groups").document(task.groupId).collection("tasks").document(task.id)
        try ref.setData(from: task)
    }
    static func toggleDone(groupId: String, taskId: String, value: Bool) async throws {
        try await Firestore.firestore().collection("groups").document(groupId).collection("tasks").document(taskId)
            .updateData(["isDone": value, "updatedAt": Date()])
    }
}
