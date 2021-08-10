import SFUIKit

enum FavoritesViewState: String, Identifiable, Hashable, CaseIterable {
    // MARK: - States
    
    case empty
    case hasContent
    case none
    
    // MARK: - Identifier
    
    var id: String { rawValue }
}
