import Foundation

enum SettingsViewAlertActivation: Identifiable, Hashable {
    case clearCache
    case removeFavoritesList(RemoveFavorites)
    
    var id: Int {
        switch self {
        case .clearCache:
            return 1
        case .removeFavoritesList(let type):
            return 2 * 10 + type.id
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
