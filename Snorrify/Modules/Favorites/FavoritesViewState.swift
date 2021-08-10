import SFUIKit

enum FavoritesViewState: Identifiable, Hashable, CaseIterable {
    // MARK: - States
    
    case empty(SFImageTextPlaceholderViewContract)
    case noSearchResults(SFTextPlaceholderViewContract)
    case withFavorites([SFCellFaveViewContract])
    case loading(message: String)
    case error(SFTextPlaceholderViewContract)
    case none
    
    // MARK: - Identifier
    
    var id: Int { _id }
    
    private var _id: Int {
        switch self {
        case .none:
            return 0
        case .error:
            return 1
        case .loading:
            return 2
        case .withFavorites:
            return 3
        case .noSearchResults:
            return 4
        case .empty:
            return 5
        }
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs._id == rhs._id
    }
    
    static func != (lhs: Self, rhs: Self) -> Bool {
        lhs._id != rhs._id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    // MARK: - Case Iterable
    
    /// Use only as mock while preview in SwiftUI's views.
    static var allCases: [FavoritesViewState] {
        return [
            .none,
            .error(.mock),
            .loading(message: LocalizationKey.loading.localizedString.capitalized),
            .withFavorites([.mock(fave: true), .mock(fave: false)]),
            .noSearchResults(.mock),
            .empty(.mockFavorites)
        ]
    }
}
