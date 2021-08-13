import Foundation

final class DBSearchItemResponse: DBFaveItemResponse {
    // MARK: - Properties
    
    var fave: Bool = false
    
    // MARK: - Mocks
    
    static var bananiSearchMock: DBSearchItemResponse {
        .init(item: .bananiMock)
    }
    
    static var skiljaSearchMock: DBSearchItemResponse {
        .init(item: .skiljaMock)
    }
    
    static var fallegurSearchMock: DBSearchItemResponse {
        .init(item: .fallegurMock)
    }
}

// MARK: - Extension of Array

extension Array where Element == DBSearchItemResponse {
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
