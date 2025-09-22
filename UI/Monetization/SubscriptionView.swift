
import SwiftUI
struct SubscriptionView: View {
    @StateObject private var iap = IAPService()
    var body: some View {
        VStack(spacing: 16) {
            Text("Dayline Premium").font(.title2).bold()
            PlanComparisonView()
            if iap.products.isEmpty { ProgressView() }
            else {
                ForEach(iap.products, id: \.id) { p in
                    VStack(spacing: 6) {
                        Text(p.displayName).font(.headline)
                        Text(p.displayPrice).font(.subheadline)
                        Button("Buy") { Task { await iap.buy(p) } }.buttonStyle(.borderedProminent)
                    }.padding().frame(maxWidth: .infinity).background(RoundedRectangle(cornerRadius: 12).stroke(.quaternary)).padding(.horizontal)
                }
            }
            Button("Restore Purchases") { Task { await iap.restore() } }.buttonStyle(.bordered)
            Text(iap.hasPremium() ? "✅ Active Premium" : "Free plan").foregroundStyle(iap.hasPremium() ? .green : .secondary)
            Spacer()
        }
        .navigationTitle("Premium")
        .task { await iap.load() }
    }
}
struct PlanComparisonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Free vs Premium").bold()
            Label("Up to 2 groups", systemImage: "checkmark.circle")
            Label("Up to 3 attachments per message", systemImage: "checkmark.circle")
            Divider()
            Label("Unlimited groups (Premium)", systemImage: "crown")
            Label("Unlimited attachments", systemImage: "crown")
            Label("Priority updates", systemImage: "crown")
        }.padding(.horizontal)
    }
}
