import Foundation

enum SettingsViewAlertActivation: Identifiable, Hashable {
    case clearCache(ClearCache)
    case removeFavoritesList(RemoveFavorites)
    
    var id: Int {
        switch self {
        case .clearCache(let type):
            return 1 * 10 + type.id
        case .removeFavoritesList(let type):
            return 2 * 10 + type.id
        }
    }
    
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
}
