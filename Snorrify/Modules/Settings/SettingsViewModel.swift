import Foundation
import SFUIKit

final class SettingsViewModel {
    // MARK: - Properties
    
    private let model: SettingsModel
    private let textManager: SettingsTextManager
    
    // MARK: - Life Cycle
    
    init(textManager: SettingsTextManager, model: SettingsModel) {
        self.textManager = textManager
        self.model = model
        debugPrint(self, #function)
    }
    
    deinit {
        debugPrint(self, #function)
    }
    
    // MARK: - Publishers
    
    @Published
    var alertActivationPublisher: SettingsViewAlertActivation?
    
    // MARK: - Actions
    
    func clearCache() {
        model.clearCache()
    }
    
    func removeFavoritesList() {
        model.removeFavoritesList()
        alertActivationPublisher = .removeFavoritesList(.confirmation)
    }
    
    // MARK: - Strings
    
    var title: String {
        textManager.title.capitalized
    }
    
    var alertRemoveCacheTitle: String {
        textManager.alertRemoveCacheTitle.capitalized
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
    
    // MARK: - Contracts
    
    var cacheContract: SFTableSettingsSectionViewContract {
        .init(
            header: textManager.cacheHeader,
            buttons: [
                .init(
                    id: SettingsViewCellType.clearCache.rawValue,
                    title: textManager.cacheButton.capitalized,
                    onTap: { [weak self] in
                        self?.alertActivationPublisher = .clearCache
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
                        self?.model.contactDeveloper()
                    }
                )
            ],
            footer: ""
        )
    }
    
    // MARK: - Mock / Preview
    
    static var mock: SettingsViewModel {
        .init(textManager: .mock, model: .mock)
    }
}
