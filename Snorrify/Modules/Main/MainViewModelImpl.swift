import Foundation

class MainViewModelImpl: MainViewModel {
    private let textManager: MainTextManager
    private let model: MainModel
    
    required init(textManager: MainTextManager,
                  model: MainModel) {
        self.textManager = textManager
        self.model = model
    }
    
    static var mock: Self {
        .init(
            textManager: MainTextManagerImpl(),
            model: MainModelImpl()
        )
    }
}
