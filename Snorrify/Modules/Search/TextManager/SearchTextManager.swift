import Foundation

struct SearchTextManager {
    static var mock: Self = .init()
    
    var searchText: String {
        LocalizationKey.search.localizedString
    }
    
    var loadingText: String {
        LocalizationKey.loading.localizedString
    }
    
    var noDataPlaceholderTitle: String {
        LocalizationKey.Search.Placeholder.title.localizedString
    }
    
    var noDataPlaceholderDescription: String {
        LocalizationKey.Search.Placeholder.description.localizedString
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
