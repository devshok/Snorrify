import Foundation

final class DBKit: ObservableObject {
    // MARK: - Singleton
    
    static var shared: DBKit = .init()
    
    // MARK: - Aliases
    
    typealias Success = Bool
    
    // MARK: - Properties
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let localStorage: UserDefaults
    
    // MARK: - Initialization
    
    init(encoder: JSONEncoder = .init(),
         decoder: JSONDecoder = .init(),
         localStorage: UserDefaults = .standard
    ) {
        self.encoder = encoder
        self.decoder = decoder
        self.localStorage = localStorage
        self.updateAllPublishers()
    }
    
    // MARK: - Publishers
    
    @Published
    private(set) var favorites: [DBFaveItemResponse] = []
    
    @Published
    private(set) var searchResults: [DBSearchItemResponse] = []
    
    // MARK: - Internal API
    
    func clearAll() {
        DBKey.allCases.forEach { key in
            clear(for: key)
        }
    }
    
    func clear(for key: DBKey) {
        switch key {
        case .favorites:
            removeAllFavorites()
        case .searchResults:
            removeAllSearchResults()
        }
    }
    
    @discardableResult
    func removeLast(for key: DBKey) -> Success {
        switch key {
        case .favorites:
            return removeLastFavorite()
        case .searchResults:
            return removeLastSearchResult()
        }
    }
    
    // MARK: - Private General API
    
    private func updateAllPublishers() {
        DBKey.allCases.forEach { key in
            updatePublisher(for: key)
        }
    }
    
    private func updatePublisher(for key: DBKey) {
        switch key {
        case .favorites:
            updateFavoritesPublisherIfNeeds()
        case .searchResults:
            updateSearchResultsPublisher()
        }
    }
}

// MARK: - Private Getters & Setters

private extension DBKit {
    @discardableResult
    func set<T: Encodable>(_ someData: T?, for key: DBKey) -> Success {
        guard let data = someData else {
            debugPrint(#function, #line, key.rawValue, "data is nil")
            return false
        }
        do {
            let encoded = try encoder.encode(data)
            localStorage.set(encoded, forKey: key.rawValue)
            return true
        } catch {
            debugPrint(#function, #line, key.rawValue, error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func get<T: Decodable>(for key: DBKey) -> T? {
        guard let data = localStorage.object(forKey: key.rawValue) as? Data else {
            debugPrint(#function, #line, key.rawValue, "data is nil")
            return nil
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            debugPrint(#function, #line, key.rawValue, error.localizedDescription)
            return nil
        }
    }
}

// MARK: - Favorites

extension DBKit {
    @discardableResult
    func add(favorite someFavorite: DBFaveItemResponse?) -> Success {
        guard let newItem = someFavorite else {
            debugPrint(#function, #line, "a new item is nil")
            return false
        }
        guard !newItem.id.isEmpty else {
            debugPrint(#function, #line, "a new item (\(newItem.item?.word ?? "nil")) has no id")
            return false
        }
        guard !innerFavorites.contains(newItem) else {
            debugPrint(#function, #line, "a new item (\(newItem.item?.word ?? "nil")) is duplicated")
            return false
        }
        var buffer = innerFavorites
        buffer.append(newItem)
        innerFavorites = buffer.onlyUniques().sortedDescending()
        favorites = innerFavorites.sortedDescending()
        updateSearchResultsPublisher()
        return true
    }
    
    @discardableResult
    func remove(favorite someFavorite: DBFaveItemResponse?) -> Success {
        guard let target = someFavorite else {
            debugPrint(#function, #line, "favorite is nil")
            return false
        }
        var buffer = innerFavorites
        buffer.removeAll(where: {
            $0 == target
        })
        innerFavorites = buffer.onlyUniques().sortedDescending()
        favorites = innerFavorites.sortedDescending()
        updateSearchResultsPublisher()
        return true
    }
    
    @discardableResult
    func contains(favorite someFavorite: SearchItemResponse?) -> Success {
        guard let item = someFavorite else {
            debugPrint(#function, #line, "favorite is nil")
            return false
        }
        return innerFavorites
            .map { $0.item }
            .compactMap { $0 }
            .contains(item)
    }
    
    private func removeAllFavorites() {
        innerFavorites = []
        favorites = []
        updateSearchResultsPublisher()
    }
    
    @discardableResult
    private func removeLastFavorite() -> Success {
        guard !innerFavorites.isEmpty else {
            debugPrint(#function, #line, "favorite is empty")
            return false
        }
        var changingList = innerFavorites
        changingList.removeLast()
        innerFavorites = changingList.sortedDescending()
        favorites = innerFavorites.sortedDescending()
        updateSearchResultsPublisher()
        return true
    }
    
    private var innerFavorites: [DBFaveItemResponse] {
        get {
            return (get(for: .favorites) ?? []).sortedDescending()
        }
        set {
            set(newValue.onlyUniques(), for: .favorites)
        }
    }
    
    private func updateFavoritesPublisherIfNeeds() {
        if favorites != innerFavorites {
            favorites = innerFavorites
        }
    }
    
    private func isFave(searchItem: DBSearchItemResponse) -> Bool {
        guard let item = searchItem.item else {
            debugPrint(#function, #line, "item is nil")
            return false
        }
        return innerFavorites
            .map { $0.item }
            .compactMap { $0 }
            .contains(item)
    }
}

// MARK: - Search Results

extension DBKit {
    @discardableResult
    func add(searchResult someSearchResult: DBSearchItemResponse?) -> Success {
        guard let newItem = someSearchResult else {
            debugPrint(#function, #line, "a new item is nil")
            return false
        }
        guard !newItem.id.isEmpty else {
            debugPrint(#function, #line, "a new item (\(newItem.item?.word ?? "nil")) has no id")
            return false
        }
        guard !innerSearchResults.contains(newItem) else {
            if remove(searchResult: newItem) {
                return add(searchResult: newItem)
            } else {
                debugPrint(#function, #line, "a new item (\(newItem.item?.word ?? "nil")) is impossible to add. #1")
                return false
            }
        }
        guard innerSearchResults.count < 6 else {
            if removeLastSearchResult() {
                return add(searchResult: newItem)
            } else {
                debugPrint(#function, #line, "a new item \(newItem.item?.word ?? "nil") is impossible to add. #2")
                return false
            }
        }
        var buffer = innerSearchResults
        buffer.append(newItem)
        innerSearchResults = buffer.onlyUniques().sortedDescending()
        updateSearchResultsPublisher()
        return true
    }
    
    @discardableResult
    func remove(searchResult someSearchResult: DBSearchItemResponse?) -> Success {
        guard let target = someSearchResult else {
            debugPrint(#function, #line, "item is nil")
            return false
        }
        var buffer = innerSearchResults
        buffer.removeAll(where: {
            $0 == target
        })
        innerSearchResults = buffer.onlyUniques().sortedDescending()
        updateSearchResultsPublisher()
        return true
    }
    
    @discardableResult
    private func removeLastSearchResult() -> Success {
        guard !innerSearchResults.isEmpty else {
            debugPrint(#function, #line, "no search results")
            return false
        }
        var changingList = innerSearchResults
        changingList.removeLast()
        innerSearchResults = changingList.sortedDescending()
        updateSearchResultsPublisher()
        return true
    }
    
    private func removeAllSearchResults() {
        innerSearchResults = []
        searchResults = []
    }
    
    private var innerSearchResults: [DBSearchItemResponse] {
        get {
            let result: [DBSearchItemResponse] = get(for: .searchResults) ?? []
            return result
                .map {
                    $0.fave = isFave(searchItem: $0)
                    return $0
                }
                .sortedDescending()
        }
        set {
            set(newValue.onlyUniques(), for: .searchResults)
        }
    }
    
    private func updateSearchResultsPublisher() {
        searchResults = innerSearchResults
    }
}
