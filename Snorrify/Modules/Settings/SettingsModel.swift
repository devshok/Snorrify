import SwiftUI
import Combine
import SFNetKit
import StoreKit
import MessageUI

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
    
    func buildMailModule(result: Binding<Result<MFMailComposeResult, Error>?>) -> some View {
        let contract: MailViewContract = {
            return .init(recipient: feedbackMailRecipient,
                         subject: feedbackMailSubject)
        }()
        return MailView(result: result, contract: contract)
    }
    
    // MARK: - Mail Helpers
    
    private var feedbackMailRecipient: String {
        let body = configString(for: .bodyMail)
        let firstDomain = configString(for: .firstDomainMail)
        let secondDomain = configString(for: .secondDomainMail)
        return LocalizationKey.mail(body, firstDomain, secondDomain).localizedString
    }
    
    private var feedbackMailSubject: String {
        let system: String = {
            let name = UIDevice.current.systemName
            let version = UIDevice.current.systemVersion
            return [name, version].joined(separator: ": ")
        }()
        let device: String = {
            let model = UIDevice.current.localizedModel
            let prefix = LocalizationKey.device.localizedString.capitalized
            return [prefix, model].joined(separator: ": ")
        }()
        let subjectPrefix = LocalizationKey.mailSubject.localizedString.capitalized
        let subjectPostfix = "\(device), \(system)"
        let subject = "\(subjectPrefix)" + " (\(subjectPostfix))"
        return subject
    }
    
    private func configString(for key: Bundle.AccessKey) -> String {
        do {
            return try Bundle.main.getValue(for: key)
        } catch let accessError as Bundle.AccessError {
            debugPrint(self, #function, accessError.rawValue)
            return ""
        } catch {
            debugPrint(self, #function, error.localizedDescription)
            return ""
        }
    }
    
    // MARK: - Mock / Preview
    
    static var mock: SettingsModel  = .init(dbKit: .shared, netKit: .default)
}
