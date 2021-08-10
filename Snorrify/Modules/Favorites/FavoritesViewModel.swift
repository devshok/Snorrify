import SwiftUI
import SFUIKit
import Combine

final class FavoritesViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: FavoritesTextManager
    private var events: Set<AnyCancellable> = []
    private var mockMode: Bool = false
    
    // MARK: - Observed Objects
    
    @ObservedObject
    private var model: FavoritesModel
    
    // MARK: - Publishers
    
    @Published
    var viewState: FavoritesViewState = .none
    
    @Published
    var showErrorAlert: Bool = false
    
    @Published
    var errorAlertTitle: String = ""
    
    @Published
    var errorAlertDescription: String = ""
    
    @Published
    var favoritesPublisher: [SFCellFaveViewContract] = []
    
    // MARK: - Life Cycle
    
    init(textManager: FavoritesTextManager, model: FavoritesModel) {
        self.textManager = textManager
        self.model = model
        listenEvents()
    }
    
    private init(textManager: FavoritesTextManager,
                 model: FavoritesModel,
                 mockViewState: FavoritesViewState = .none
    ) {
        self.textManager = textManager
        self.model = model
        self.mockMode = true
        self.viewState = mockViewState
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
        guard !mockMode else { return }
        model.$data
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.handleFailure(errorDescription: error.localizedDescription)
                }
            }, receiveValue: { [weak self] data in
                self?.handle(newFavorites: data)
            })
            .store(in: &events)
        handle(newFavorites: model.data)
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
    
    var defaultErrorAlertTitle: String {
        textManager.error.capitalized
    }
    
    var defaultErrorAlertDescription: String {
        textManager.uknownErrorDescription.capitalizedOnlyFirstLetter
    }
    
    var okText: String {
        textManager.ok.uppercased()
    }
}

// MARK: - View Actions

extension FavoritesViewModel {
    func search(for text: String) {
        model.search(for: text)
    }
    
    func tap(faveId: String) {
        print(self, #function, #line, faveId)
    }
    
    func hideKeyboard() {
        UIApplication.shared.hideKeyboard()
    }
    
    private func unfave(faveId: String) {
        print(self, #function, #line, faveId)
    }
}

// MARK: - Coming Failures

private extension FavoritesViewModel {
    func handleFailure(errorDescription description: String) {
        errorAlertTitle = textManager.error.capitalized
        errorAlertDescription = description.capitalizedOnlyFirstLetter
        if !errorAlertTitle.isEmpty || !errorAlertDescription.isEmpty {
            showErrorAlert = true
        }
    }
}

// MARK: - Coming Values

private extension FavoritesViewModel {
    func handle(newFavorites items: [DBFaveItemResponse]) {
        if items.isEmpty && !model.isSearching {
            viewState = .empty
        } else {
            favoritesPublisher = favoritesContracts(by: items)
            viewState = .hasContent
        }
    }
}

// MARK: - Contracts

extension FavoritesViewModel {
    var noneContract: SFTextPlaceholderViewContract {
        let title = textManager.empty.capitalizedOnlyFirstLetter
        let description = textManager.uknownErrorDescription.capitalizedOnlyFirstLetter
        return .init(title: title, description: description)
    }
    
    var noSearchResultsContract: SFTextPlaceholderViewContract {
        let title = textManager.noResults.title.capitalized
        let description = textManager.noResults.description.capitalizedOnlyFirstLetter
        return .init(title: title, description: description)
    }
    
    var emptyContract: SFImageTextPlaceholderViewContract {
        let title = textManager.favorites.capitalized
        let description = textManager.placeholder.capitalizedOnlyFirstLetter
        return .init(type: .favorites, title: title, description: description)
    }
}

private extension FavoritesViewModel {
    func favoritesContracts(by data: [DBFaveItemResponse]) -> [SFCellFaveViewContract] {
        return data.map {
            .init(id: $0.id,
                  text: $0.item?.word ?? .emptyFormString,
                  fave: true,
                  faveButtonAction: { [weak self] id in
                
                self?.unfave(faveId: id)
            })
        }
    }
}

// MARK: - Mock / Preview

extension FavoritesViewModel {
    static func mock(state: FavoritesViewState) -> FavoritesViewModel {
        .init(textManager: .mock, model: .mock, mockViewState: state)
    }
}
