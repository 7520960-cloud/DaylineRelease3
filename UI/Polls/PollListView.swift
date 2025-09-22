
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PollListView: View {
    let groupId: String
    @State private var polls: [DLPoll] = []
    @State private var listener: ListenerRegistration?
    var body: some View {
        List(polls.sorted { $0.createdAt > $1.createdAt }) { p in
            NavigationLink(destination: PollDetailView(poll: p)) {
                VStack(alignment: .leading) { Text(p.question).bold(); Text("\(p.options.count) options").font(.footnote).foregroundStyle(.secondary) }
            }
        }
        .navigationTitle("Polls")
        .toolbar { NavigationLink(destination: PollCreateView(groupId: groupId)) { Image(systemName: "plus") } }
        .onAppear {
            listener = Firestore.firestore().collection("groups").document(groupId).collection("polls").addSnapshotListener { snap, _ in
                self.polls = snap?.documents.compactMap { try? $0.data(as: DLPoll.self) } ?? []
            }
        }
        .onDisappear { listener?.remove() }
    }
}
