
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TimelineView: View {
    let groupId: String
    @State private var tasks: [DLTask] = []
    @State private var listener: ListenerRegistration?
    var body: some View {
        List {
            Section("Tasks") {
                ForEach(tasks) { t in
                    NavigationLink(destination: TaskDetailView(task: t)) {
                        VStack(alignment: .leading) {
                            Text(t.title).bold()
                            if let due = t.dueDate {
                                Text(due, style: .date).font(.footnote).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            Section {
                NavigationLink("Chat", destination: ChatView(groupId: groupId))
                NavigationLink("Polls", destination: PollListView(groupId: groupId))
                NavigationLink("Calendar", destination: CalendarScreen(groupId: groupId))
            }
        }
        .navigationTitle("Timeline")
        .toolbar { NavigationLink(destination: TaskCreateView(groupId: groupId)) { Image(systemName: "plus") } }
        .onAppear {
            listener = Firestore.firestore().collection("groups").document(groupId).collection("tasks").addSnapshotListener { snap, _ in
                self.tasks = snap?.documents.compactMap { try? $0.data(as: DLTask.self) } ?? []
            }
        }
        .onDisappear { listener?.remove() }
    }
}
