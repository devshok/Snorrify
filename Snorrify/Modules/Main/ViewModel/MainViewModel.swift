import Foundation
import SwiftUI

class MainViewModel {
    // MARK: - Properties
    
    private let textManager: MainTextManager
    private let model: MainModel
    
    // MARK: - Initialization
    
    init(
        textManager: MainTextManager,
        model: MainModel
    ) {
        self.textManager = textManager
        self.model = model
    }
    
    deinit {
        debugPrint(self, #function)
    }
    
    // MARK: - Interface
    
    func tabTitle(for tab: MainViewTab) -> String {
        return textManager.tabTitle(for: tab).capitalized
    }
    
    func buildSearchModule() -> SearchView {
        return model.buildSearchModule()
    }
    
    func buildFavoritesModule() -> FavoritesView {
        return model.buildFavoritesModule()
    }
    
    func buildSettingsModule() -> SettingsView {
        return model.buildSettingsModule()
    }
    
    // MARK: - Mock / Preview
    
    static var mock: MainViewModel {
        return MainViewModel(
            textManager: MainTextManager(),
            model: MainModel(netKit: .default, dbKit: .shared)
        )
    }
}
