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
    
    // MARK: - Strings
    
    var title: String {
        textManager.title.capitalized
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
                        self?.model.clearCache()
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
                        self?.model.removeFavoritesList()
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
                        self?.model.rateApp()
                    }
                ),
                .init(
                    id: SettingsViewCellType.contactDeveloper.rawValue,
                    title: textManager.feedbackContactDeveloperButton.capitalized,
                    onTap: { [weak self] in
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
