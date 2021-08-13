import Foundation

class DBFaveItemResponse: Codable, Identifiable, Hashable {
    // MARK: - Properties
    
    var id: String {
        return item?.id ?? ""
    }
    
    let item: SearchItemResponse?
    let recordedAt: Date
    
    init(item: SearchItemResponse?) {
        self.item = item
        self.recordedAt = Date()
    }
    
    // MARK: - Equatable
    
    static func == (lhs: DBFaveItemResponse, rhs: DBFaveItemResponse) -> Bool {
        lhs.id == rhs.id
    }
    
    static func != (lhs: DBFaveItemResponse, rhs: DBFaveItemResponse) -> Bool {
        lhs.id != rhs.id
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(item)
        hasher.combine(recordedAt)
    }
    
    // MARK: - Mocks
    
    static var bananiFaveMock: DBFaveItemResponse {
        .init(item: .bananiMock)
    }
    
    static var skiljaFaveMock: DBFaveItemResponse {
        .init(item: .skiljaMock)
    }
    
    static var fallegurFaveMock: DBFaveItemResponse {
        .init(item: .fallegurMock)
    }
}

// MARK: - Extension of Array

extension Array where Element == DBFaveItemResponse {
    func sortedDescending() -> [Element] {
        return self.sorted(by: {
            $0.recordedAt.compare($1.recordedAt) == .orderedDescending
        })
    }
    
    func onlyUniques() -> [Element] {
        let set = Set(self)
        return Array(set)
    }
}
