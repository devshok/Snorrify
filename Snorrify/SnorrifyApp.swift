import SwiftUI
import SFNetKit

@main
struct SnorrifyApp: App {
    private let appConfiguration: AppConfiguration
    
    init() {
        appConfiguration = AppConfiguration(netKit: NetKit.default)
    }
    
    var body: some Scene {
        WindowGroup {
            appConfiguration.buildMainModule()
        }
    }
}
