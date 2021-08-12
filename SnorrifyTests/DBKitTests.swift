import XCTest
import Combine
import SwiftUI
@testable import Snorrify

class DBKitTests: XCTestCase {
    // MARK: - DB
    
    private var db: DBKit = .init()
    
    // MARK: - Other Properties
    
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Life Cycles
    
    override func setUp() {
        db.clear(for: .favorites)
    }
    
    override func tearDown() {
        db.clear(for: .favorites)
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - Favorites
    
    func testFavoritesInitialCountWhenDBClean() {
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesInsertOneItemValidCount() {
        let mock: DBFaveItemResponse = .bananiMock
        db.add(favorite: mock)
        XCTAssertEqual(db.favorites.count, 1)
    }
    
    func testFavoritesInsertOneItemValidEquatable() {
        let mock: DBFaveItemResponse = .bananiMock
        db.add(favorite: mock)
        let result = db.favorites.first
        XCTAssertEqual(mock, result)
    }
    
    func testFavoritesInsertSeveralItemsValidCount() {
        addThreeMockItemsInDB()
        XCTAssertEqual(db.favorites.count, 3)
    }
    
    func testFavoritesInsertSeveralItemsValidEquatable() {
        let mocks: [DBFaveItemResponse] = [.bananiMock, .skiljaMock, .fallegurMock]
            .sorted(by: { $0.recordedAt.compare($1.recordedAt) == .orderedDescending })
        mocks.forEach { favorite in
            db.add(favorite: favorite)
        }
        let result = db.favorites
        XCTAssertEqual(result, mocks)
    }
    
    func testFavoritesInsertItemsExcludingDuplicates() {
        let mock: DBFaveItemResponse = .bananiMock
        let anotherMock: DBFaveItemResponse = .bananiMock
        let mocks = [mock, anotherMock]
        mocks.forEach { db.add(favorite: $0) }
        XCTAssertTrue(db.favorites.count == 1 && db.favorites.first == mock)
    }
    
    func testFavoritesInsertEmptyItem() {
        db.add(favorite: .init(item: nil))
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesPublisherAfterInsertingSeveralItems() {
        let mocks: [DBFaveItemResponse] = [.bananiMock, .skiljaMock, .fallegurMock]
            .sorted(by: { $0.recordedAt.compare($1.recordedAt) == .orderedDescending })
        let expectation = XCTestExpectation(description: "\(#function)")
        var result: [DBFaveItemResponse] = []
        db.$favorites
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { items in
                result = items
                if mocks.count == items.count {
                    expectation.fulfill()
                }
            })
            .store(in: &events)
        mocks.forEach { db.add(favorite: $0) }
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(mocks, result)
    }
    
    func testFavoritesRemoveOneItemValidCount() {
        let banani = DBFaveItemResponse.bananiMock
        addThreeMockItemsInDB()
        db.remove(favorite: banani)
        XCTAssertEqual(db.favorites.count, 2)
    }
    
    func testFavoritesRemoveSeveralItemsValidCountAndValidEquatable() {
        let banani = DBFaveItemResponse.bananiMock
        let skilja = DBFaveItemResponse.skiljaMock
        let fallegur = DBFaveItemResponse.fallegurMock
        addThreeMockItemsInDB()
        db.remove(favorite: banani)
        db.remove(favorite: skilja)
        XCTAssertTrue(db.favorites.count == 1 && db.favorites.first == fallegur)
    }
    
    func testFavoritesRemoveAllFavoritesValidCount() {
        addThreeMockItemsInDB()
        db.clear(for: .favorites)
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesClearDBTotallyValidCount() {
        addThreeMockItemsInDB()
        db.clearAll()
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesRemoveLastItemValidCount() {
        addThreeMockItemsInDB()
        let removed = db.removeLast(for: .favorites)
        XCTAssertTrue(db.favorites.count == 2 && removed)
    }
    
    func testFavoritesPublisherAfterRemovingSeveralItems() {
        let expectation = XCTestExpectation(description: "\(#function)")
        let banani = DBFaveItemResponse.bananiMock
        let skilja = DBFaveItemResponse.skiljaMock
        let fallegur = DBFaveItemResponse.fallegurMock
        addThreeMockItemsInDB()
        var result: [DBFaveItemResponse] = []
        db.$favorites
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { items in
                result = items
                if items.count == 1 && result.count == 1 {
                    expectation.fulfill()
                }
            })
            .store(in: &events)
        db.remove(favorite: skilja)
        db.remove(favorite: fallegur)
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(result.count == 1 && result.first == banani)
    }
    
    func testFavoritesContainsItemValidBoolValue() {
        addThreeMockItemsInDB()
        XCTAssertTrue(db.contains(favorite: .bananiMock))
    }
    
    func testFavoritesNotContainsItemValidBoolValue() {
        db.add(favorite: .bananiMock)
        db.add(favorite: .skiljaMock)
        XCTAssertFalse(db.contains(favorite: .fallegurMock))
    }
}

// MARK: - Favorites Helpers

private extension DBKitTests {
    func addThreeMockItemsInDB() {
        let banani = DBFaveItemResponse.bananiMock
        let skilja = DBFaveItemResponse.skiljaMock
        let fallegur = DBFaveItemResponse.fallegurMock
        let mocks = [banani, skilja, fallegur]
            .sorted(by: { $0.recordedAt.compare($1.recordedAt) == .orderedDescending })
        mocks.forEach { db.add(favorite: $0) }
    }
}
