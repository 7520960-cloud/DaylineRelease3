
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct GroupListView: View {
    @State private var groups: [DLGroup] = []
    @State private var listener: ListenerRegistration?
    @StateObject private var iap = IAPService()

    var body: some View {
        List(groups.sorted{ $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }) { g in
            NavigationLink(destination: TimelineView(groupId: g.id)) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(g.name).font(.headline)
                    Text((g.type?.capitalized ?? "Group")).font(.footnote).foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Groups")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    NavigationLink(destination: CreateJoinView()) { Image(systemName: "person.3") }
                    NavigationLink(destination: SubscriptionView()) { Image(systemName: "crown") }
                }
            }
        }
        .task { await iap.load() }
        .onAppear {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            listener = Firestore.firestore().collection("groups").whereField("members", arrayContains: uid)
                .addSnapshotListener { snap, _ in
                    let arr = snap?.documents.compactMap { try? $0.data(as: DLGroup.self) } ?? []
                    self.groups = arr
                }
        }
        .onDisappear { listener?.remove() }
    }
}
