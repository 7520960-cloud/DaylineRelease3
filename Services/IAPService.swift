
import StoreKit
@MainActor
final class IAPService: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchased: Set<String> = []
    let productIds: Set<String> = ["dayline.premium.monthly", "dayline.premium.yearly"]
    func load() async {
        do { products = try await Product.products(for: Array(productIds)) } catch { print("IAP load error", error) }
        await refreshPurchased()
    }
    func buy(_ product: Product) async {
        do {
            let res = try await product.purchase()
            switch res {
            case .success(let verif):
                let t = try checkVerified(verif); await t.finish(); await refreshPurchased()
            case .pending: print("Purchase pending")
            case .userCancelled: print("User cancelled purchase")
            default: break
            }
        } catch { print("purchase error", error) }
    }
    func restore() async { try? await AppStore.sync(); await refreshPurchased() }
    func refreshPurchased() async {
        var ids: Set<String> = []
        for await r in Transaction.currentEntitlements { if case .verified(let t) = r { ids.insert(t.productID) } }
        purchased = ids
    }
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result { case .verified(let safe): return safe; case .unverified: throw NSError(domain:"IAP", code:0) }
    }
    func hasPremium() -> Bool { !purchased.isEmpty }
    func environment() -> String { Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" ? "Sandbox" : "Production" }
}
