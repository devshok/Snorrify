import Foundation
import SFUIKit

enum ResultsViewState {
    case options
    case forms
    case error(SFTextPlaceholderViewContract)
    case loading
    case noResults
    case none
}
