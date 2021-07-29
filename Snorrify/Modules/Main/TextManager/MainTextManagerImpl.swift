import Foundation

// MARK: - Interface

final class MainTextManagerImpl: MainTextManager {
    func tabTitle(for tab: MainViewTab) -> String {
        return title(for: tab)
    }
    
    func navTitle(for tab: MainViewTab) -> String {
        return title(for: tab)
    }
}

// MARK: - Implementation

private extension MainTextManagerImpl {
    private typealias LK = LocalizationKey
    
    func title(for tab: MainViewTab) -> String {
        switch tab {
        case .search:
            return LK.search.localizedString
        case .favorites:
            return LK.favorites.localizedString
        case .settings:
            return LK.settings.localizedString
        }
    }
}
