import Foundation

enum SearchViewSheetActivation: String, Identifiable, Hashable {
    case results
    case history
    
    var id: String { rawValue }
}
