import SwiftUI
import Combine

final class SettingsModel {
    // MARK: - Properties
    
    private let dbKit: DBKit
    
    // MARK: - Life Cycle
    
    init(dbKit: DBKit) {
        self.dbKit = dbKit
        debugPrint(self, #function)
    }
    
    deinit {
        debugPrint(self, #function)
    }
    
    // MARK: - API
    
    func clearCache() {
        debugPrint(self, #function, #line)
    }
    
    func removeFavoritesList() {
        debugPrint(self, #function, #line)
    }
    
    func rateApp() {
        debugPrint(self, #function, #line)
    }
    
    func contactDeveloper() {
        debugPrint(self, #function, #line)
    }
    
    // MARK: - Mock / Preview
    
    static var mock: SettingsModel  = .init(dbKit: .shared)
}
