import SwiftUI
import SFNetKit

@main
struct SnorrifyApp: App {
    private let appConfiguration: AppConfiguration
    
    init() {
        let netKit = NetKit.default
        let dbKit = DBKit.shared
        appConfiguration = AppConfiguration(netKit: netKit, dbKit: dbKit)
    }
    
    var body: some Scene {
        WindowGroup {
            appConfiguration.buildMainModule()
        }
    }
}
