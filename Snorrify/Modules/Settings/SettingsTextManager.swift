import Foundation

struct SettingsTextManager {
    // MARK: - General Strings
    
    var title: String {
        LocalizationKey.settings.localizedString
    }
    
    var yes: String {
        LocalizationKey.yes.localizedString
    }
    
    var no: String {
        LocalizationKey.no.localizedString
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
    
    var alertRemoveCacheQuestionTitle: String {
        LocalizationKey.Settings.Cache.ClearCacheAlert.question.localizedString
    }
    
    var alertRemoveCacheConfirmationTitle: String {
        LocalizationKey.Settings.Cache.ClearCacheAlert.confirmation.localizedString
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
    
    var alertRemoveFavoritesQuestionTitle: String {
        LocalizationKey.Settings.Data.RemoveFavoritesAlert.question.localizedString
    }
    
    var alertRemoveFavoritesConfirmationTitle: String {
        LocalizationKey.Settings.Data.RemoveFavoritesAlert.confirmation.localizedString
    }
    
    // MARK: - Feedback Strings
    
    var feedbackHeader: String {
        LocalizationKey.Settings.Feedback.header.localizedString
    }
    
    var feedbackRateAppButton: String {
        LocalizationKey.Settings.Feedback.Button.rateApp.localizedString
    }
    
    var feedbackContactDeveloperButton: String {
        LocalizationKey.Settings.Feedback.Button.contactDeveloper.localizedString
    }
    
    var feedbackFailedSendMailAlertTitle: String {
        LocalizationKey.Settings.Feedback.Alert.failedSendMail.localizedString
    }
    
    var feedbackSentMailAlertTitle: String {
        LocalizationKey.Settings.Feedback.Alert.sentMail.localizedString
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self = .init()
}
