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
        dbKit.add(favorite: .skiljaFaveMock)
        dbKit.add(favorite: .bananiFaveMock)
        dbKit.add(favorite: .fallegurFaveMock)
        return favoritesView
    }
    
    func buildSettingsModule() -> SettingsView {
        let view = SettingsView()
        return view
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
}
