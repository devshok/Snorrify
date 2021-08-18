import Foundation

struct SettingsTextManager {
    // MARK: - General Strings
    
    var title: String {
        LocalizationKey.settings.localizedString
    }
    
    var alertRemoveCacheQuestionTitle: String {
        LocalizationKey.Settings.Cache.ClearCacheAlert.question.localizedString
    }
    
    var alertRemoveCacheConfirmationTitle: String {
        LocalizationKey.Settings.Cache.ClearCacheAlert.confirmation.localizedString
    }
    
    var yes: String {
        LocalizationKey.yes.localizedString
    }
    
    var no: String {
        LocalizationKey.no.localizedString
    }
    
    var alertRemoveFavoritesQuestionTitle: String {
        LocalizationKey.Settings.Data.RemoveFavoritesAlert.question.localizedString
    }
    
    var alertRemoveFavoritesConfirmationTitle: String {
        LocalizationKey.Settings.Data.RemoveFavoritesAlert.confirmation.localizedString
    }
    
    // MARK: - Cache Strings
    
    var cacheHeader: String {
        LocalizationKey.Settings.Cache.header.localizedString
    }
    
    var cacheButton: String {
        LocalizationKey.Settings.Cache.button.localizedString
    }
    
    var cacheFooter: String {
        LocalizationKey.Settings.Cache.footer.localizedString
    }
    
    // MARK: - Data Strings
    
    var dataHeader: String {
        LocalizationKey.Settings.Data.header.localizedString
    }
    
    var dataButton: String {
        LocalizationKey.Settings.Data.button.localizedString
    }
    
    var dataFooter: String {
        LocalizationKey.Settings.Data.footer.localizedString
    }
    
    // MARK: - Feedback Strings
    
    var feedbackHeader: String {
        LocalizationKey.Settings.Feedback.header.localizedString
    }
    
    var feedbackRateAppButton: String {
        LocalizationKey.Settings.Feedback.buttonRateApp.localizedString
    }
    
    var feedbackContactDeveloperButton: String {
        LocalizationKey.Settings.Feedback.buttonContactDeveloper.localizedString
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self = .init()
}
