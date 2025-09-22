
import SwiftUI

struct TaskDetailView: View {
    @State var task: DLTask
    var body: some View {
        List {
            Section {
                HStack {
                    Text(task.title).font(.title2).bold()
                    Spacer()
                    Button {
                        Task { try? await TaskService.toggleDone(groupId: task.groupId, taskId: task.id, value: !task.isDone); task.isDone.toggle() }
                    } label: {
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    }
                }
            }
            if let n = task.notes { Section("Notes") { Text(n) } }
            if let due = task.dueDate { Section("When") { Text(due, style: .date); Text(due, style: .time) } }
            if let r = task.repeatRule { Section("RRULE") { Text(r) } }
            if let imgs = task.imageURLs, !imgs.isEmpty {
                Section("Images") { ScrollView(.horizontal) { HStack { ForEach(imgs, id: \.self) { u in AsyncImage(url: URL(string: u)) { $0.resizable().scaledToFill() } placeholder: { ProgressView() } .frame(width: 120, height: 90).clipped().cornerRadius(8) } } }.frame(height: 100) }
            }
            if let audio = task.audioURL { Section("Audio") { AudioPlayerView(urlString: audio) } }
            if let lat = task.latitude, let lon = task.longitude { Section("Location") { Text(String(format:"%.5f, %.5f", lat, lon)) } }
        }
        .navigationTitle("Task")
        .toolbar { ShareLink(item: ICSExporter.icsString(for: task).data(using: .utf8)!, preview: SharePreview(task.title)) { Image(systemName: "square.and.arrow.up") } }
    }
}
