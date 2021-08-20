import XCTest
@testable import Snorrify

class MockTests: XCTestCase {
    // MARK: - Properties
    
    var result: SearchItemResponse?
    var results: [SearchItemResponse]?
    var lastTestFunctionName = ""
    var didLoadSingleEntity = false
    
    // MARK: - Life Cycles
    
    override func tearDown() {
        if didLoadSingleEntity {
            printLastResult(result)
        } else {
            printLastResults()
        }
        result = nil
    }
    
    // MARK: - Helpers
    
    private func printLastResult(_ result: SearchItemResponse?) {
        print("\n")
        print(
            lastTestFunctionName,
            result?.id ?? "no id",
            result?.word ?? "no word",
            result?.wordClass.rawValue ?? "no word class 👎"
        )
    }
    
    private func printLastResults() {
        print("\n")
        if let results = self.results, !results.isEmpty {
            results.forEach {
                printLastResult($0)
            }
        } else {
            print("no results 👎")
        }
    }
    
    // MARK: - Tests
    
    func testSkiljaMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.skilja)
        XCTAssertNotNil(result)
    }
    
    func testBananiMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.banani)
        XCTAssertNotNil(result)
    }
    
    func testFallegurMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.fallegur)
        XCTAssertNotNil(result)
    }
    
    func testSkiljaOptionsMockNotNil() {
        defer { didLoadSingleEntity = false }
        lastTestFunctionName = "\(#function)"
        results = MockManager.shared.loadFromJson(.skiljaOptions)
        XCTAssertNotNil(results)
    }
    
    func testEinnNumeralMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.einnNumeral)
        XCTAssertNotNil(result)
    }
    
    func testEinnOtherPronounMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.einnOtherPronoun)
        XCTAssertNotNil(result)
    }
    
    func testHannMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.hann)
        XCTAssertNotNil(result)
    }
    
    func testSigMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.sig)
        XCTAssertNotNil(result)
    }
    
    func testLeiðinlegaMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.leiðinlega)
        XCTAssertNotNil(result)
    }
    
    func testAnnarMockNotNil() {
        defer { didLoadSingleEntity = true }
        lastTestFunctionName = "\(#function)"
        result = MockManager.shared.loadFromJson(.annar)
        XCTAssertNotNil(result)
    }
}
