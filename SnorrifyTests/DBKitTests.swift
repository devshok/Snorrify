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
        db.clearAll()
    }
    
    override func tearDown() {
        db.clearAll()
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - Favorites
    
    func testFavoritesInitialCountWhenDBClean() {
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesInsertOneItemValidCount() {
        let mock: DBFaveItemResponse = .bananiFaveMock
        db.add(favorite: mock)
        XCTAssertEqual(db.favorites.count, 1)
    }
    
    func testFavoritesInsertOneItemValidEquatable() {
        let mock: DBFaveItemResponse = .bananiFaveMock
        db.add(favorite: mock)
        let result = db.favorites.first
        XCTAssertEqual(mock, result)
    }
    
    func testFavoritesInsertSeveralItemsValidCount() {
        addThreeFaveMockItemsInDB()
        XCTAssertEqual(db.favorites.count, 3)
    }
    
    func testFavoritesInsertSeveralItemsValidEquatable() {
        let mocks: [DBFaveItemResponse] = [.bananiFaveMock, .skiljaFaveMock, .fallegurFaveMock]
            .sorted(by: { $0.recordedAt.compare($1.recordedAt) == .orderedDescending })
        mocks.forEach { favorite in
            db.add(favorite: favorite)
        }
        let result = db.favorites
        XCTAssertEqual(result, mocks)
    }
    
    func testFavoritesInsertItemsExcludingDuplicates() {
        let mock = DBFaveItemResponse.bananiFaveMock
        let anotherMock = DBFaveItemResponse.bananiFaveMock
        let mocks = [mock, anotherMock]
        mocks.forEach { db.add(favorite: $0) }
        XCTAssertTrue(db.favorites.count == 1 && db.favorites.first == mock)
    }
    
    func testFavoritesInsertEmptyItem() {
        db.add(favorite: .init(item: nil))
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesPublisherAfterInsertingSeveralItems() {
        let mocks: [DBFaveItemResponse] = [.bananiFaveMock, .skiljaFaveMock, .fallegurFaveMock]
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
        let banani = DBFaveItemResponse.bananiFaveMock
        addThreeFaveMockItemsInDB()
        db.remove(favorite: banani)
        XCTAssertEqual(db.favorites.count, 2)
    }
    
    func testFavoritesRemoveSeveralItemsValidCountAndValidEquatable() {
        let banani = DBFaveItemResponse.bananiFaveMock
        let skilja = DBFaveItemResponse.skiljaFaveMock
        let fallegur = DBFaveItemResponse.fallegurFaveMock
        addThreeFaveMockItemsInDB()
        db.remove(favorite: banani)
        db.remove(favorite: skilja)
        XCTAssertTrue(db.favorites.count == 1 && db.favorites.first == fallegur)
    }
    
    func testFavoritesRemoveAllFavoritesValidCount() {
        addThreeFaveMockItemsInDB()
        db.clear(for: .favorites)
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesClearDBTotallyValidCount() {
        addThreeFaveMockItemsInDB()
        db.clearAll()
        XCTAssertEqual(db.favorites.count, .zero)
    }
    
    func testFavoritesRemoveLastItemValidCount() {
        addThreeFaveMockItemsInDB()
        let removed = db.removeLast(for: .favorites)
        XCTAssertTrue(db.favorites.count == 2 && removed)
    }
    
    func testFavoritesPublisherAfterRemovingSeveralItems() {
        let expectation = XCTestExpectation(description: "\(#function)")
        let banani = DBFaveItemResponse.bananiFaveMock
        let skilja = DBFaveItemResponse.skiljaFaveMock
        let fallegur = DBFaveItemResponse.fallegurFaveMock
        addThreeFaveMockItemsInDB()
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
        addThreeFaveMockItemsInDB()
        XCTAssertTrue(db.contains(favorite: .bananiMock))
    }
    
    func testFavoritesNotContainsItemValidBoolValue() {
        db.add(favorite: .bananiFaveMock)
        db.add(favorite: .skiljaFaveMock)
        XCTAssertFalse(db.contains(favorite: .fallegurMock))
    }
}

// MARK: - Favorites Helpers

private extension DBKitTests {
    func addThreeFaveMockItemsInDB() {
        let banani = DBFaveItemResponse.bananiFaveMock
        let skilja = DBFaveItemResponse.skiljaFaveMock
        let fallegur = DBFaveItemResponse.fallegurFaveMock
        let mocks = [banani, skilja, fallegur]
            .sorted(by: { $0.recordedAt.compare($1.recordedAt) == .orderedDescending })
        mocks.forEach { db.add(favorite: $0) }
    }
}

// MARK: - Search Results Tests

extension DBKitTests {
    func testSearchResultsInitialValidCount() {
        XCTAssertTrue(db.searchResults.isEmpty)
    }
    
    func testSearchResultsInsertOneItemValidCount() {
        let mock: DBSearchItemResponse = .bananiSearchMock
        db.add(searchResult: mock)
        XCTAssertEqual(db.searchResults.count, 1)
    }
    
    func testSearchResultsInsertOneItemValidEquatable() {
        let mock: DBSearchItemResponse = .bananiSearchMock
        db.add(searchResult: mock)
        let result = db.searchResults.first
        XCTAssertEqual(mock, result)
    }
    
    func testSearchResultsInsertSeveralItemsValidCount() {
        addThreeSearchResultsMockItemsInDB()
        XCTAssertEqual(db.searchResults.count, 3)
    }
    
    func testSearchResultsInsertEmptyItem() {
        db.add(searchResult: .init(item: nil))
        XCTAssertEqual(db.searchResults.count, .zero)
    }
    
    func testSearchResultsRemoveOneItemValidCount() {
        let banani = DBSearchItemResponse.bananiSearchMock
        addThreeSearchResultsMockItemsInDB()
        db.remove(searchResult: banani)
        XCTAssertEqual(db.searchResults.count, 2)
    }
    
    func testSearchResultsRemoveLastItem() {
        addThreeSearchResultsMockItemsInDB()
        db.removeLast(for: .searchResults)
        XCTAssertEqual(db.searchResults.count, 2)
    }
    
    func testSearchResultsRemoveSpecificItem() {
        addThreeSearchResultsMockItemsInDB()
        let banani = DBSearchItemResponse.bananiSearchMock
        let fallegur = DBSearchItemResponse.fallegurSearchMock
        let skilja = DBSearchItemResponse.skiljaSearchMock
        db.remove(searchResult: banani)
        db.remove(searchResult: skilja)
        XCTAssertTrue(db.searchResults.count == 1 && db.searchResults.first == fallegur)
    }
}

// MARK: - Search Results Helpers

private extension DBKitTests {
    func addThreeSearchResultsMockItemsInDB() {
        let banani = DBSearchItemResponse.bananiSearchMock
        let skilja = DBSearchItemResponse.skiljaSearchMock
        let fallegur = DBSearchItemResponse.fallegurSearchMock
        let mocks = [banani, skilja, fallegur]
            .sorted(by: { $0.recordedAt.compare($1.recordedAt) == .orderedDescending })
        mocks.forEach { db.add(searchResult: $0) }
    }
}
