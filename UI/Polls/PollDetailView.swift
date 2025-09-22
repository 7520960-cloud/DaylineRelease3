
import SwiftUI
import FirebaseAuth

struct PollDetailView: View {
    let poll: DLPoll
    @State private var myChoice: Int? = nil
    @State private var alreadyVoted = false

    var body: some View {
        List {
            Section { Text(poll.question).font(.title3).bold() }
            Section("Vote") {
                ForEach(poll.options.indices, id: \.self) { i in
                    HStack { Text(poll.options[i]); Spacer(); if myChoice == i { Image(systemName: "checkmark") } }
                        .contentShape(Rectangle())
                        .onTapGesture { if !alreadyVoted { myChoice = i } }
                }
                Button("Vote") { Task { try? await vote() } }.disabled(myChoice == nil || alreadyVoted)
                if alreadyVoted { Text("You have already voted").font(.caption).foregroundStyle(.secondary) }
            }
            Section("Results") {
                let counts = countsByOption()
                ForEach(poll.options.indices, id: \.self) { i in HStack { Text(poll.options[i]); Spacer(); Text("\(counts[i])") } }
            }
        }
        .navigationTitle("Polls")
        .task { detectMyVote() }
    }
    func detectMyVote() { let uid = Auth.auth().currentUser?.uid ?? ""; if let e = poll.votes[uid] { myChoice = e; alreadyVoted = true } }
    func vote() async throws { guard !alreadyVoted, let choice = myChoice else { return }; try await PollService.vote(groupId: poll.groupId, pollId: poll.id, option: choice); alreadyVoted = true }
    func countsByOption() -> [Int] { var arr = Array(repeating: 0, count: poll.options.count); for (_, idx) in poll.votes { if idx >= 0 && idx < arr.count { arr[idx] += 1 } } ; if let mine=myChoice, !alreadyVoted { arr[mine] += 1 }; return arr }
}
