import Foundation
import Combine
import SwiftUI
import SFUIKit

class SearchViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: SearchTextManager
    private let model: SearchModel
    private var events = Set<AnyCancellable>()
    
    // MARK: - Property Wrappers
    
    @Published
    var viewState: SearchViewState
    
    // MARK: - Life Cycle
    
    init(viewState: SearchViewState = .defaultEmpty,
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
        model.$searching
            .sink(receiveValue: { [weak self] isSearching in
                if isSearching { self?.viewState = .loading }
            })
            .store(in: &events)
        model.$lastRequestResult
            .sink(receiveValue: { [weak self] result in
            })
            .store(in: &events)
    }
    
    // MARK: - For Subviews
    
    var searchText: String {
        textManager.searchText
    }
    
    var loadingText: String {
        textManager.loadingText
    }
    
    var placeholderContract: SFImageTextPlaceholderViewContract {
        .init(
            type: .search,
            title: textManager.placeholderTitle,
            description: textManager.placeholderDescription
        )
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
