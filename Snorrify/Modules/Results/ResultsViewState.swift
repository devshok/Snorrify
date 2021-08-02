import Foundation
import SFUIKit

enum ResultsViewState {
    case options(SFTableOptionsViewContract)
    case forms
    case error(SFTextPlaceholderViewContract)
    case loading
    case noResults
    case none
}
