import Foundation

enum SettingsViewSheetActivation: String, Identifiable, Hashable {
    case clearCache
    case removeFavoritesList
    
    var id: String { rawValue }
}
