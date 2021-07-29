import Foundation

protocol MainViewModel {
    init(textManager: MainTextManager, model: MainModel)
    
    func tabTitle(for tab: MainViewTab) -> String
    func buildSearchModule() -> SearchView
    func buildFavoritesModule() -> FavoritesView
    func buildSettingsModule() -> SettingsView
    
    static var mock: Self { get }
}
