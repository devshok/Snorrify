import Foundation
import SFUIKit
import SwiftUI
import Combine
import MessageUI

final class SettingsViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: SettingsTextManager
    private var events: Set<AnyCancellable> = []
    private let byteCountFormatter: ByteCountFormatter
    private var usedCachedMemoryString: String = "(\(String.emptyFormString))"
    
    // MARK: - Observed Objects
    
    @ObservedObject
    private var model: SettingsModel
    
    // MARK: - Publishers
    
    @Published
    var alertActivationPublisher: SettingsViewAlertActivation?
    
    @Published
    var cacheContract: SFTableSettingsSectionViewContract = .init()
    
    @Published
    var presentMailView: Bool = false
    
    // MARK: - Life Cycle
    
    init(textManager: SettingsTextManager,
         model: SettingsModel,
         byteCountFormatter: ByteCountFormatter
    ) {
        self.textManager = textManager
        self.model = model
        self.byteCountFormatter = byteCountFormatter
        self.cacheContract = newCacheContract()
        listenEvents()
    }
    
    deinit {
        removeEvents()
        debugPrint(self, #function)
    }
    
    // MARK: - Events
    
    private func listenEvents() {
        model.$cachedBytesPublisher
            .sink(receiveValue: { [weak self] bytes in
                let byteCount = Int64(bytes)
                if let string = self?.byteCountFormatter.string(fromByteCount: byteCount) {
                    self?.usedCachedMemoryString = "(\(string))"
                } else {
                    self?.usedCachedMemoryString = "(\(String.emptyFormString))"
                }
                if let self = self {
                    self.cacheContract = self.newCacheContract()
                }
            })
            .store(in: &events)
        
        let bytesCount = Int64(model.cachedBytesPublisher)
        let bytesString = byteCountFormatter.string(fromByteCount: bytesCount)
        usedCachedMemoryString = "(\(bytesString))"
        cacheContract = newCacheContract()
    }
    
    private func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - Actions
    
    func clearCache() {
        model.clearCache()
        alertActivationPublisher = .clearCache(.confirmation)
    }
    
    func removeFavoritesList() {
        model.removeFavoritesList()
        alertActivationPublisher = .removeFavoritesList(.confirmation)
    }
    
    func buildMailModule(result: Binding<Result<MFMailComposeResult, Error>?>) -> some View {
        return model.buildMailModule(result: result)
    }
    
    // MARK: - Strings
    
    var title: String {
        textManager.title.capitalized
    }
    
    var alertRemoveCacheQuestionTitle: String {
        textManager.alertRemoveCacheQuestionTitle.capitalized
    }
    
    var alertRemoveCacheConfirmationTitle: String {
        textManager
            .alertRemoveCacheConfirmationTitle
            .capitalizedOnlyFirstLetter
    }
    
    var yesText: String {
        textManager.yes.capitalized
    }
    
    var noText: String {
        textManager.no.capitalized
    }
    
    var alertRemoveFavoritesQuestionTitle: String {
        textManager.alertRemoveFavoritesQuestionTitle.capitalized
    }
    
    var alertRemoveFavoritesConfirmationTitle: String {
        textManager
            .alertRemoveFavoritesConfirmationTitle
            .capitalizedOnlyFirstLetter
    }
    
    var alertMailSuccess: String {
        textManager
            .feedbackSentMailAlertTitle
            .capitalizedOnlyFirstLetter
    }
    
    var alertMailFailure: String {
        textManager
            .feedbackFailedSendMailAlertTitle
            .capitalizedOnlyFirstLetter
    }
    
    // MARK: - Contracts
    
    private func newCacheContract() -> SFTableSettingsSectionViewContract {
        .init(
            header: textManager.cacheHeader,
            buttons: [
                .init(
                    id: SettingsViewCellType.clearCache.rawValue,
                    title: textManager.cacheButton.capitalized
                        + " \(usedCachedMemoryString)",
                    onTap: { [weak self] in
                        self?.alertActivationPublisher = .clearCache(.question)
                    }
                )
            ],
            footer: textManager.cacheFooter.capitalizedOnlyFirstLetter
        )
    }
    
    var dataContract: SFTableSettingsSectionViewContract {
        .init(
            header: textManager.dataHeader,
            buttons: [
                .init(
                    id: SettingsViewCellType.removeFavoritesList.rawValue,
                    title: textManager.dataButton.capitalized,
                    onTap: { [weak self] in
                        self?.alertActivationPublisher = .removeFavoritesList(.question)
                    }
                )
            ],
            footer: textManager.dataFooter.capitalizedOnlyFirstLetter
        )
    }
    
    var feedbackContract: SFTableSettingsSectionViewContract {
        .init(
            header: textManager.feedbackHeader,
            buttons: [
                .init(
                    id: SettingsViewCellType.rateApp.rawValue,
                    title: textManager.feedbackRateAppButton.capitalized,
                    onTap: { [weak self] in
                        self?.alertActivationPublisher = .none
                        self?.model.rateApp()
                    }
                ),
                .init(
                    id: SettingsViewCellType.contactDeveloper.rawValue,
                    title: textManager.feedbackContactDeveloperButton.capitalized,
                    onTap: { [weak self] in
                        self?.alertActivationPublisher = .none
                        if MFMailComposeViewController.canSendMail() {
                            self?.presentMailView = true
                        }
                    }
                )
            ],
            footer: ""
        )
    }
    
    // MARK: - Mock / Preview
    
    static var mock: SettingsViewModel {
        .init(textManager: .mock, model: .mock, byteCountFormatter: .init())
    }
}
