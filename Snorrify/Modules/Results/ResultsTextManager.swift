import Foundation

struct ResultsTextManager {
    static var mock: Self = .init()
    
    var whichOne: String {
        LocalizationKey.whichOne.localizedString
    }
    
    var empty: String {
        LocalizationKey.empty.localizedString
    }
    
    var close: String {
        LocalizationKey.close.localizedString
    }
    
    var error: String {
        LocalizationKey.error.localizedString
    }
    
    var loading: String {
        LocalizationKey.loading.localizedString
    }
    
    var noResultsPlaceholderTitle: String {
        LocalizationKey.noResults.localizedString
    }
    
    func noResultsPlaceholderDescription(for word: String) -> String {
        return LocalizationKey.for(word: word).localizedString
    }
    
    var noResultsPlaceholderDefaultDescription: String {
        return LocalizationKey.Search.Placeholder.tryAnotherSearch.localizedString
    }
}
