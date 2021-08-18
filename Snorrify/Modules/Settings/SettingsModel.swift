import SwiftUI
import Combine
import SFNetKit
import StoreKit

final class SettingsModel: ObservableObject {
    // MARK: - Properties
    
    private let dbKit: DBKit
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Observed Objects
    
    @ObservedObject
    private var netKit: NetKit
    
    // MARK: - Publishers
    
    @Published
    var cachedBytesPublisher: Int = .zero
    
    // MARK: - Life Cycle
    
    init(dbKit: DBKit, netKit: NetKit) {
        self.dbKit = dbKit
        self.netKit = netKit
        listenEvents()
        debugPrint(self, #function)
    }
    
    deinit {
        removeEvents()
        debugPrint(self, #function)
    }
    
    // MARK: - Events
    
    private func listenEvents() {
        netKit.$bytesCachePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.cachedBytesPublisher, on: self)
            .store(in: &events)
    }
    
    private func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - API
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        dbKit.clear(for: .searchResults)
        cachedBytesPublisher = .zero
    }
    
    func removeFavoritesList() {
        dbKit.clear(for: .favorites)
    }
    
    func rateApp() {
        if let windowScene = UIApplication.shared.windows.first?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    func contactDeveloper() {
        debugPrint(self, #function, #line)
    }
    
    // MARK: - Mock / Preview
    
    static var mock: SettingsModel  = .init(dbKit: .shared, netKit: .default)
}
