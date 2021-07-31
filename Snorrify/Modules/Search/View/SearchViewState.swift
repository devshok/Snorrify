import Foundation

enum SearchViewState {
    case defaultEmpty
    case defaultWithLastResults
    case loading
    case noResults
    case error(title: String, description: String)
}
