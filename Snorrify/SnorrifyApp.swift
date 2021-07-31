import SwiftUI
import SFNetKit

@main
struct SnorrifyApp: App {
    private var appConfiguration = AppConfiguration(netKit: NetKit.default)
    
    var body: some Scene {
        WindowGroup {
            appConfiguration.buildMainModule()
        }
    }
}
