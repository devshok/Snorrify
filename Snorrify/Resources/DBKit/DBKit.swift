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
        }
    }
    
    @discardableResult
    func removeLast(for key: DBKey) -> Success {
        switch key {
        case .favorites:
            return removeLastFavorite()
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
            debugPrint(#function, #line, "a new item has no id")
            return false
        }
        guard !innerFavorites.contains(newItem) else {
            debugPrint(#function, #line, "a new item is duplicated")
            return false
        }
        var buffer = innerFavorites
        buffer.append(newItem)
        innerFavorites = buffer.onlyUniques().sortedDescending()
        favorites = innerFavorites.sortedDescending()
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
        return true
    }
    
    private func removeAllFavorites() {
        innerFavorites = []
        favorites = []
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
    
    private func sort(_ favorites: [DBFaveItemResponse]) -> [DBFaveItemResponse] {
        return favorites.sorted(by: {
            $0.recordedAt.compare($1.recordedAt) == .orderedDescending
        })
    }
    
    private func updateFavoritesPublisherIfNeeds() {
        if favorites != innerFavorites {
            favorites = innerFavorites
        }
    }
}
