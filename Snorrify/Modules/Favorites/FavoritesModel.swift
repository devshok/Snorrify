import Combine
import SFNetKit

final class FavoritesModel: ObservableObject {
    // MARK: - Properties
    
    private let dbKit: DBKit
    private let netKit: NetKit
    private var events: Set<AnyCancellable> = []
    private var allItems: [DBFaveItemResponse] = []
    
    private var searchText: String = "" {
        didSet {
            data = filteredItems.sortedDescending()
        }
    }
    
    // MARK: - Publishers
    
    @Published
    var data: [DBFaveItemResponse] = []
    
    // MARK: - Life Cycle
    
    init(dbKit: DBKit, netKit: NetKit) {
        self.dbKit = dbKit
        self.netKit = netKit
        listenEvents()
    }
    
    deinit {
        removeEvents()
        data.removeAll()
        debugPrint(self, #function, #line)
    }
    
    // MARK: - Results Module
    
    private lazy var resultsTextManager = ResultsTextManager()
    private lazy var resultsModel = ResultsModel(netKit: netKit, dbKit: dbKit, data: [])
    private lazy var resultsViewModel = ResultsViewModel(textManager: resultsTextManager, model: resultsModel)
}

// MARK: - Events

private extension FavoritesModel {
    func listenEvents() {
        dbKit.$favorites
            .sink(receiveValue: { [weak self] items in
                self?.allItems = items
                self?.data = (self?.filteredItems ?? []).sortedDescending()
            })
            .store(in: &events)
        data = dbKit.favorites
    }
    
    func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
}

// MARK: - View Model -> Output

extension FavoritesModel {
    func unfave(_ item: DBFaveItemResponse?) {
        dbKit.remove(favorite: item)
    }
    
    func search(for text: String) {
        searchText = text
    }
    
    func buildResultsModule(data: SearchItemResponse?) -> ResultsView {
        let data: [SearchItemResponse] = data == nil ? [] : [data!]
        resultsModel.dataPublisher = data
        return .init(viewModel: resultsViewModel)
    }
}

// MARK: - Internal Getters

extension FavoritesModel {
    var isSearching: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - Private Getters

private extension FavoritesModel {
    var filteredItems: [DBFaveItemResponse] {
        switch isSearching {
        case true:
            return allItems
                .filter { $0.item?.word.contains(searchText) ?? false }
        case false:
            return allItems
        }
    }
}

// MARK: - Mock / Preview

extension FavoritesModel {
    static var mock: FavoritesModel = .init(dbKit: .shared, netKit: .default)
}
