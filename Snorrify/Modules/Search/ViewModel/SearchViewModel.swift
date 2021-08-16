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
    private var selectedHistoryItem: SearchItemResponse?
    
    // MARK: - Publishers
    
    @Published
    var viewState: SearchViewState
    
    @Published
    var history: [SFCellFaveViewContract] = []
    
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
        debugPrint(self, #function)
    }
    
    // MARK: - Events
    
    func listenEvents() {
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
        
        model.$historySearchResults
            .sink(receiveValue: { [weak self] history in
                self?.handle(history: history)
            })
            .store(in: &events)
    }
    
    func search(for word: String) {
        lastSearchingText = word
        model.search(word: word)
    }
    
    // MARK: - For Subviews
    
    var lastResultsText: String {
        textManager.lastResults.capitalized
    }
    
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
    
    func buildSearchResultsModule() -> ResultsView {
        return model.buildResultsModule(data: searchResults)
    }
    
    func select(historyId id: String) {
        selectedHistoryItem = model.historySearchResults
            .filter { $0.id == id }
            .map { $0 }
            .first?
            .item
    }
    
    func buildHistoryModule() -> ResultsView {
        let data: [SearchItemResponse] = selectedHistoryItem == nil ? [] : [selectedHistoryItem!]
        return model.buildResultsModule(data: data)
    }
    
    // MARK: - Handlers
    
    private func handleNewRequestResult(
        _ result: Published<Result<[SearchItemResponse], NetworkError>?>.Publisher.Output
    ) {
        searchResults.removeAll()
        switch result {
        case .success(let response):
            if response.isEmpty {
                withAnimation(.spring()) {
                    viewState = .noResults
                }
            } else {
                if case .loading = viewState {
                    viewState = validDefaultViewState
                }
                searchResults = response
                viewState = .readyToShowResults
            }
            if response.count == 1 {
                model.addToHistory(item: response.first)
            }
        case .failure(let error):
            withAnimation(.spring()) {
                viewState = .error(
                    title: textManager.errorText,
                    description: error.localized
                )
            }
        case .none:
            break
        }
    }
    
    private func handle(history: [DBSearchItemResponse]) {
        self.history = history
            .map { historyItem in
                let id = historyItem.item?.id ?? ""
                let text = historyItem.item?.word ?? .emptyFormString
                let fave = historyItem.fave
                return .init(id: id, text: text, fave: .constant(fave), faveButtonAction: { [weak self] _ in
                    switch fave {
                    case true:
                        self?.model.unfave(item: historyItem)
                    case false:
                        self?.model.fave(item: historyItem)
                    }
                })
            }
        
        if case .defaultEmpty = viewState {
            viewState = validDefaultViewState
        } else if case .defaultWithLastResults = viewState {
            viewState = validDefaultViewState
        }
    }
    
    private var validDefaultViewState: SearchViewState {
        switch history.isEmpty {
        case true:
            return .defaultEmpty
        case false:
            return .defaultWithLastResults
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
