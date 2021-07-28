import Foundation

protocol MainViewModel {
    init(textManager: MainTextManager, model: MainModel)
    static var mock: Self { get }
}
