import Foundation

protocol MainModel {
    func buildSearchModule() -> SearchView
    func buildFavoritesModule() -> FavoritesView
    func buildSettingsModule() -> SettingsView
}
