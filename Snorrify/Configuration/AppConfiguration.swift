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
}

// MARK: - Main Module Configuration

private extension AppConfiguration {
    var mainViewModel: MainViewModel {
        return MainViewModel(textManager: mainTextManager, model: mainModel)
    }
    
    var mainTextManager: MainTextManager {
        return MainTextManager()
    }
    
    var mainModel: MainModel {
        return MainModel(netKit: netKit)
    }
}
