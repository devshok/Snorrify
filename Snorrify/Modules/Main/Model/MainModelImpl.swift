import Foundation
import SwiftUI
import SFNetKit

struct MainModelImpl: MainModel {
    // MARK: - Properties
    
    let netKit: NetKit
    
    // MARK: - Initialization
    
    init(netKit: NetKit) {
        self.netKit = netKit
    }
    
    // MARK: - Interface
    
    func buildSearchModule() -> SearchView {
        let model = SearchModel(netKit: netKit)
        let textManager = SearchTextManager()
        let viewModel = SearchViewModel(
            viewState: .noResults,
            textManager: textManager,
            model: model
        )
        let view = SearchView(viewModel: viewModel)
        return view
    }
    
    func buildFavoritesModule() -> FavoritesView {
        let view = FavoritesView()
        return view
    }
    
    func buildSettingsModule() -> SettingsView {
        let view = SettingsView()
        return view
    }
}
