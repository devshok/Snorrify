import Foundation

struct FavoritesTextManager {
    // MARK: - Aliases
    
    private typealias LK = LocalizationKey
    
    // MARK: - Strings
    
    var favorites: String {
        LK.favorites.localizedString
    }
    
    var search: String {
        LK.search.localizedString
    }
    
    var placeholder: String {
        LK.Favorites.placeholderDescription.localizedString
    }
    
    var noResults: (title: String, description: String) {
        let title = LK.noResults.localizedString
        let description = LK.Search.Placeholder.tryAnotherSearch.localizedString
        return (title, description)
    }
    
    var error: String {
        LocalizationKey.error.localizedString
    }
    
    var loading: String {
        LocalizationKey.loading.localizedString
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self = .init()
}
