import Foundation
import Combine
import SwiftUI
import SFUIKit
import SFNetKit

class SearchViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: SearchTextManager
    private let model: SearchModel
    private var events = Set<AnyCancellable>()
    private var lastSearchingText: String = ""
    private var searchResults: [SearchItemResponse] = []
    private var subscribedEvents = false
    
    // MARK: - Property Wrappers
    
    @Published
    var viewState: SearchViewState
    
    @Published
    var showResults: Bool = false
    
    // MARK: - Life Cycle
    
    init(viewState: SearchViewState,
         textManager: SearchTextManager,
         model: SearchModel
    ) {
        self.viewState = viewState
        self.textManager = textManager
        self.model = model
    }
    
    deinit {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - Subscribers
    
    func listenEvents() {
        guard !subscribedEvents else { return }
        defer { subscribedEvents = true }
        model.$searching
            .sink(receiveValue: { [weak self] isSearching in
                if isSearching {
                    self?.viewState = .loading
                }
            })
            .store(in: &events)
        
        model.$noSearchResults
            .sink(receiveValue: { [weak self] noSearchResults in
                if noSearchResults {
                    self?.viewState = .noResults
                }
            })
            .store(in: &events)
        
        model.$lastRequestResult
            .sink(receiveValue: { [weak self] result in
                self?.handleNewRequestResult(result)
            })
            .store(in: &events)
    }
    
    func search(for word: String) {
        lastSearchingText = word
        model.search(word: word)
    }
    
    // MARK: - For Subviews
    
    var searchText: String {
        textManager.searchText
    }
    
    var loadingText: String {
        textManager.loadingText
    }
    
    var imagePlaceholderContract: SFImageTextPlaceholderViewContract {
        .init(
            type: .search,
            title: textManager.noDataPlaceholderTitle,
            description: textManager.noDataPlaceholderDescription
        )
    }
    
    var noResultsPlaceholderContract: SFTextPlaceholderViewContract {
        let title = textManager.noResultsPlaceholderTitle
        let description: String = {
            switch lastSearchingText.isEmpty {
            case true:
                return textManager.noResultsPlaceholderDefaultDescription
            case false:
                return textManager.noResultsPlaceholderDescription(for: lastSearchingText)
            }
        }()
        return .init(
            title: title,
            description: description
        )
    }
    
    func hideKeyboard() {
        UIApplication.shared.hideKeyboard()
    }
    
    func buildResultsModule() -> ResultsView {
        return model.buildResultsModule(data: searchResults)
    }
    
    // MARK: - Handlers
    
    private func handleNewRequestResult(
        _ result: Published<Result<[SearchItemResponse], NetworkError>?>.Publisher.Output
    ) {
        searchResults.removeAll()
        switch result {
        case .success(let response):
            if response.isEmpty {
                viewState = .noResults
            } else {
                if case .loading = viewState {
                    viewState = .defaultEmpty
                }
                searchResults = response
                showResults = true
            }
        case .failure(let error):
            viewState = .error(
                title: textManager.errorText,
                description: error.localized
            )
        case .none:
            break
        }
    }
    
    // MARK: - Preview / Mock
    
    static func mock(state: SearchViewState) -> SearchViewModel {
        return .init(
            viewState: state,
            textManager: .mock,
            model: .mock
        )
    }
}
