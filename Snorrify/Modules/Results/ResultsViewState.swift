import Foundation
import SFUIKit

enum ResultsViewState {
    case options(SFTableOptionsViewContract)
    case noun
    case error(SFTextPlaceholderViewContract)
    case loading
    case noResults
    case none
}
