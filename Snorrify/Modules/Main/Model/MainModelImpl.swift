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
        let view = SearchView()
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
