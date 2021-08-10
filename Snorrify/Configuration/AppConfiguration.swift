import Foundation
import SFNetKit
import SFUIKit
import SwiftUI

final class AppConfiguration {
    // MARK: - Properties
    
    private let netKit: NetKit
    private let dbKit: DBKit
    
    // MARK: - Interface
    
    init(netKit: NetKit, dbKit: DBKit) {
        self.netKit = netKit
        self.dbKit = dbKit
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
        return MainModel(netKit: netKit, dbKit: dbKit)
    }()
}
