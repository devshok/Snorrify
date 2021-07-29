import Foundation

enum SearchViewState: String, CaseIterable, Identifiable, Hashable {
    case defaultEmpty
    case defaultWithLastResults
    case loading
    case noResults
    
    var id: String {
        UUID().uuidString
    }
}
