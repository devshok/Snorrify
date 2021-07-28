import SwiftUI
import SFNetKit

@main
struct SnorrifyApp: App {
    var body: some Scene {
        WindowGroup {
            AppConfiguration.shared.buildMainModule()
        }
    }
}
