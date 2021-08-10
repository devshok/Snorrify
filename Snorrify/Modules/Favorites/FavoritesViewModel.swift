import SwiftUI
import SFUIKit
import Combine

final class FavoritesViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: FavoritesTextManager
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Observed Objects
    
    @ObservedObject
    private var model: FavoritesModel
    
    // MARK: - Publishers
    
    @Published
    var viewState: FavoritesViewState = .none
    
    // MARK: - Life Cycle
    
    init(textManager: FavoritesTextManager, model: FavoritesModel) {
        self.textManager = textManager
        self.model = model
        listenEvents()
    }
    
    deinit {
        removeEvents()
        debugPrint(self, #function, #line)
    }
}

// MARK: - Events

private extension FavoritesViewModel {
    func listenEvents() {
        model.$data
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleFailure(errorDescription: error.localizedDescription)
                }
            }, receiveValue: { [weak self] data in
                self?.handle(newFavorites: data)
            })
            .store(in: &events)
    }
    
    func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
}

// MARK: - View Texts

extension FavoritesViewModel {
    var title: String {
        textManager.favorites.capitalized
    }
    
    var searchPlaceholder: String {
        textManager.search.capitalized
    }
}

// MARK: - View Actions

extension FavoritesViewModel {
    func search(for text: String) {
        model.search(for: text)
    }
}

// MARK: - Coming Failures

private extension FavoritesViewModel {
    func handleFailure(errorDescription description: String) {
        let contract = errorViewContract(description: description)
        viewState = .error(contract)
    }
}

// MARK: - Coming Values

private extension FavoritesViewModel {
    func handle(newFavorites items: [DBFaveItemResponse]) {
        switch items.isEmpty {
        case true:
            let noResults = FavoritesViewState.noSearchResults(noSearchResultContract)
            let empty = FavoritesViewState.empty(emptyDefaultContract)
            viewState = model.isSearching ? noResults : empty
        case false:
            let contract = favoritesContracts(by: items)
            viewState = .withFavorites(contract)
        }
    }
}

// MARK: - Contracts

private extension FavoritesViewModel {
    func errorViewContract(description: String) -> SFTextPlaceholderViewContract {
        let title = textManager.error.capitalized
        return .init(title: title, description: description)
    }
    
    var emptyDefaultContract: SFImageTextPlaceholderViewContract {
        let title = textManager.favorites.capitalized
        let description = textManager.placeholder.capitalizedOnlyFirstLetter
        return .init(type: .favorites, title: title, description: description)
    }
    
    var noSearchResultContract: SFTextPlaceholderViewContract {
        let title = textManager.noResults.title.capitalized
        let description = textManager.noResults.description.capitalizedOnlyFirstLetter
        return .init(title: title, description: description)
    }
    
    func favoritesContracts(by data: [DBFaveItemResponse]) -> [SFCellFaveViewContract] {
        return data.map {
            .init(text: $0.item?.word ?? .emptyFormString, fave: true)
        }
    }
}

// MARK: - Mock / Preview

extension FavoritesViewModel {
    static var mock: FavoritesViewModel {
        .init(textManager: .mock, model: .mock)
    }
}
