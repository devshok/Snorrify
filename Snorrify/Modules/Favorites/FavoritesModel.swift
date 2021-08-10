import Combine

final class FavoritesModel: ObservableObject {
    // MARK: - Properties
    
    private let dbKit: DBKit
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
    
    init(dbKit: DBKit) {
        self.dbKit = dbKit
        listenEvents()
    }
    
    deinit {
        removeEvents()
        data.removeAll()
        debugPrint(self, #function, #line)
    }
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
    static var mock: FavoritesModel = .init(dbKit: .shared)
}
