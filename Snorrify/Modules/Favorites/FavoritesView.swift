import SwiftUI

struct FavoritesView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("favorites view")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            FavoritesView()
                .preferredColorScheme(scheme)
        }
    }
}
