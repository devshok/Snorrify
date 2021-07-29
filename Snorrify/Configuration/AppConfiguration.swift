import Foundation
import SFNetKit
import SFUIKit
import SwiftUI

final class AppConfiguration: ObservableObject {
    @Environment(\.colorScheme)
    var colorScheme
    
    // MARK: - Properties
    
    private let netKit: NetKit
    
    // MARK: - Interface
    
    init(netKit: NetKit) {
        self.netKit = netKit
        setupGlobalAppearance()
    }
    
    func buildMainModule() -> MainView {
        return MainView(viewModel: mainViewModel)
    }
}

// MARK: - Main Module Configuration

private extension AppConfiguration {
    var mainViewModel: MainViewModel {
        return MainViewModelImpl(textManager: mainTextManager, model: mainModel)
    }
    
    var mainTextManager: MainTextManager {
        return MainTextManagerImpl()
    }
    
    var mainModel: MainModel {
        return MainModelImpl(netKit: netKit)
    }
}

// MARK: - Global Appearance Configuration

private extension AppConfiguration {
    func setupGlobalAppearance() {
        setupNavigationAppearance()
    }
    
    private func setupNavigationAppearance() {
        let color = Color.navigationBarColor(when: colorScheme)
        UINavigationBar.appearance().backgroundColor = UIColor(color)
    }
}
