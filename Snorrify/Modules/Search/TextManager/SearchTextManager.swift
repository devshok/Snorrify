import Foundation

struct SearchTextManager {
    static var mock: Self = .init()
    
    var searchText: String {
        LocalizationKey.search.localizedString
    }
    
    var loadingText: String {
        LocalizationKey.loading.localizedString
    }
    
    var placeholderTitle: String {
        LocalizationKey.Search.Placeholder.title.localizedString
    }
    
    var placeholderDescription: String {
        LocalizationKey.Search.Placeholder.description.localizedString
    }
}
