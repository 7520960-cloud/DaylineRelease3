
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

struct ChatView: View {
    let groupId: String
    @State private var messages: [DLMessage] = []
    @State private var input: String = ""
    @State private var listener: ListenerRegistration?
    @State private var lastSnapshot: DocumentSnapshot?
    @State private var loadingMore = false
    @StateObject private var locationService = LocationService()
    @State private var pendingImageURLs: [String] = []
    @State private var pendingAudioURL: String? = nil
    @State private var pendingCoordinate: CLLocationCoordinate2D? = nil
    @StateObject private var iap = IAPService()

    var body: some View {
        VStack {
            List {
                if lastSnapshot != nil {
                    Button(action: loadMore) { if loadingMore { ProgressView() } else { Text("Load earlier") } }
                }
                ForEach(messages) { msg in
                    MessageRow(msg: msg, groupId: groupId)
                }
            }.listStyle(.plain)

            ChatAttachmentBar(groupId: groupId, locationService: locationService,
                onImagesAttached: { pendingImageURLs = iap.hasPremium() ? $0 : Array($0.prefix(AppConfig.freeMaxAttachmentsPerMessage)) },
                onAudioAttached: { pendingAudioURL = $0 },
                onLocationAttached: { pendingCoordinate = $0 })

            HStack {
                TextField("Message", text: $input).textFieldStyle(.roundedBorder)
                Button { send() } label: { Image(systemName: "paperplane.fill") }
                    .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && pendingImageURLs.isEmpty && pendingAudioURL == nil && pendingCoordinate == nil)
            }.padding(.horizontal).padding(.bottom, 8)
        }
        .navigationTitle("Chat")
        .task {
            await iap.load()
            let page = await ChatService.loadInitial(groupId: groupId)
            self.messages = page.messages
            self.lastSnapshot = page.last
            listener = Firestore.firestore().collection("groups").document(groupId).collection("chat").order(by: "timestamp", descending: false)
                .addSnapshotListener { snap, _ in
                    self.messages = snap?.documents.compactMap { try? $0.data(as: DLMessage.self) } ?? []
                }
        }
        .onDisappear { listener?.remove() }
    }

    func loadMore() {
        guard !loadingMore else { return }
        loadingMore = true
        ChatService.loadMore(groupId: groupId, after: lastSnapshot) { page in
            self.messages = page.messages + self.messages
            self.lastSnapshot = page.last
            self.loadingMore = false
        }
    }

    func send() {
        let msg = DLMessage(id: UUID().uuidString, senderId: Auth.auth().currentUser?.uid ?? "unknown", senderName: Auth.auth().currentUser?.displayName ?? "User", text: input.trimmingCharacters(in: .whitespacesAndNewlines), timestamp: Date(), imageURLs: pendingImageURLs.isEmpty ? nil : pendingImageURLs, audioURL: pendingAudioURL, latitude: pendingCoordinate?.latitude, longitude: pendingCoordinate?.longitude)
        do {
            try Firestore.firestore().collection("groups").document(groupId).collection("chat").document(msg.id).setData(from: msg)
            input = ""; pendingImageURLs = []; pendingAudioURL = nil; pendingCoordinate = nil
        } catch { print("send error", error) }
    }
}
