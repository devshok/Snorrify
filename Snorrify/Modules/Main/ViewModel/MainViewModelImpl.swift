import Foundation

class MainViewModelImpl: MainViewModel {
    private let textManager: MainTextManager
    private let model: MainModel
    
    required init(textManager: MainTextManager,
                  model: MainModel) {
        self.textManager = textManager
        self.model = model
    }
    
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
    
    static var mock: Self {
        .init(
            textManager: MainTextManagerImpl(),
            model: MainModelImpl(netKit: .default)
        )
    }
}
