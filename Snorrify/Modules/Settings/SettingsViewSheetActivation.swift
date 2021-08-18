import Foundation

enum SettingsViewAlertActivation: Identifiable, Hashable {
    case clearCache(ClearCache)
    case removeFavoritesList(RemoveFavorites)
    case mail(Mail)
    case error(localizedDescription: String)
    
    var id: Int {
        switch self {
        case .clearCache(let type):
            return 10 + type.id
        case .removeFavoritesList(let type):
            return 20 + type.id
        case .mail(let type):
            return 30 + type.id
        case .error:
            return 40
        }
    }
    
    // MARK: - Clear Cache
    
    enum ClearCache: Identifiable, Hashable {
        case question, confirmation
        
        var id: Int {
            switch self {
            case .question:
                return 1
            case .confirmation:
                return 2
            }
        }
    }
    
    // MARK: - Remove Favorites
    
    enum RemoveFavorites: Identifiable, Hashable {
        case question, confirmation
        
        var id: Int {
            switch self {
            case .question:
                return 1
            case .confirmation:
                return 2
            }
        }
    }
    
    // MARK: - Mail
    
    enum Mail: Identifiable, Hashable {
        case failed, sent
        
        var id: Int {
            switch self {
            case .failed:
                return 1
            case .sent:
                return 2
            }
        }
    }
}
