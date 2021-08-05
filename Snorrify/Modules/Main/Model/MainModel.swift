import Foundation
import SwiftUI
import SFNetKit

class MainModel {
    // MARK: - Properties
    
    let netKit: NetKit
    
    // MARK: - Initialization
    
    init(netKit: NetKit) {
        self.netKit = netKit
    }
    
    // MARK: - Interface
    
    func buildSearchModule() -> SearchView {
        return searchView
    }
    
    func buildFavoritesModule() -> FavoritesView {
        let view = FavoritesView()
        return view
    }
    
    func buildSettingsModule() -> SettingsView {
        let view = SettingsView()
        return view
    }
    
    // MARK: - Search Module
    
    private lazy var searchView: SearchView = .init(viewModel: searchViewModel)
    private lazy var searchTextManager: SearchTextManager = .init()
    private lazy var searchModel: SearchModel = .init(netKit: netKit)
    private lazy var searchViewModel: SearchViewModel = .init(viewState: .defaultEmpty,
                                                              textManager: searchTextManager,
                                                              model: searchModel)
}
