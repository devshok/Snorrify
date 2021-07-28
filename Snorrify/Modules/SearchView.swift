import SwiftUI

struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("search view")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            SearchView()
                .preferredColorScheme(scheme)
        }
    }
}
