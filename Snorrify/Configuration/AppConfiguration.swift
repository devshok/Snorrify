import Foundation
import SFNetKit
import SFUIKit
import SwiftUI

final class AppConfiguration {
    @Environment(\.colorScheme)
    var colorScheme
    
    // MARK: - Properties
    
    private let netKit: NetKit
    
    // MARK: - Interface
    
    init(netKit: NetKit) {
        self.netKit = netKit
    }
    
    func buildMainModule() -> MainView {
        return MainView(viewModel: mainViewModel)
    }
    
    private lazy var mainView: MainView = {
        return .init(viewModel: mainViewModel)
    }()
    
    private lazy var mainViewModel: MainViewModel = {
        return MainViewModel(textManager: mainTextManager, model: mainModel)
    }()
    
    private lazy var mainTextManager: MainTextManager = {
        return MainTextManager()
    }()
    
    private lazy var mainModel: MainModel = {
        return MainModel(netKit: netKit)
    }()
}
