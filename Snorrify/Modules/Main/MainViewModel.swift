import Foundation

protocol MainViewModel {
    init(textManager: MainTextManager, model: MainModel)
    func tabTitle(for tab: MainViewTab) -> String
    static var mock: Self { get }
}
