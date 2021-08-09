import Foundation
import SFUIKit

enum ResultsViewState {
    case options(SFTableOptionsViewContract)
    case noun
    case error(SFTextPlaceholderViewContract)
    case verbCategories(SFTableOptionsViewContract)
    case adjectiveCategories(SFTableOptionsViewContract)
    case loading
    case noResults
    case none
}
