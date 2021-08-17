import Foundation
import SwiftUI
import SFNetKit

class MainModel {
    // MARK: - Properties
    
    private let netKit: NetKit
    private let dbKit: DBKit
    
    // MARK: - Initialization
    
    init(netKit: NetKit, dbKit: DBKit) {
        self.netKit = netKit
        self.dbKit = dbKit
    }
    
    // MARK: - Interface
    
    func buildSearchModule() -> SearchView {
        return searchView
    }
    
    func buildFavoritesModule() -> FavoritesView {
        return favoritesView
    }
    
    func buildSettingsModule() -> SettingsView {
        return settingsView
    }
    
    // MARK: - Search Module
    
    private lazy var searchView: SearchView = .init(viewModel: searchViewModel)
    private lazy var searchTextManager: SearchTextManager = .init()
    private lazy var searchModel: SearchModel = .init(netKit: netKit, dbKit: dbKit)
    private lazy var searchViewModel: SearchViewModel = .init(viewState: .defaultEmpty,
                                                              textManager: searchTextManager,
                                                              model: searchModel)
    
    // MARK: - Favorites Module
    
    private lazy var favoritesView: FavoritesView = .init(viewModel: favoritesViewModel)
    private lazy var favoritesTextManager: FavoritesTextManager = .init()
    private lazy var favoritesModel: FavoritesModel = .init(dbKit: dbKit, netKit: netKit)
    private lazy var favoritesViewModel: FavoritesViewModel = .init(textManager: favoritesTextManager,
                                                                    model: favoritesModel)
    
    // MARK: - Settings Module
    
    private lazy var settingsView: SettingsView = .init(viewModel: settingsViewModel)
    private lazy var settingsTextManager: SettingsTextManager = .init()
    private lazy var settingsModel: SettingsModel = .init(dbKit: dbKit)
    private lazy var settingsViewModel: SettingsViewModel = .init(textManager: settingsTextManager,
                                                                  model: settingsModel)
}
