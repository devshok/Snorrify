import Foundation

enum SettingsViewCellType: String, Identifiable, Hashable {
    case clearCache
    case removeFavoritesList
    case rateApp
    case contactDeveloper
    
    var id: String { rawValue }
}
