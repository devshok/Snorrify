import SwiftUI
import SFNetKit

@main
struct SnorrifyApp: App {
    @StateObject private var appConfiguration = AppConfiguration(netKit: NetKit.default)
    
    var body: some Scene {
        WindowGroup {
            appConfiguration.buildMainModule()
        }
    }
}
