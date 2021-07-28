import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("settings view")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            SettingsView()
                .preferredColorScheme(scheme)
        }
    }
}
