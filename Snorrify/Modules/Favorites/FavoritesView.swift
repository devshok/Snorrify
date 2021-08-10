import SwiftUI

struct FavoritesView: View {
    // MARK: - Environment
    @Environment(\.colorScheme)
    private var colorScheme
    
    // MARK: - Observed Objects
    // MARK: - State Objects
    // MARK: - Initialization
    
    // MARK: - Body
    
    var body: some View {
        Text("favorites view".capitalized)
    }
}

// MARK: - Current View

private extension FavoritesView {}

// MARK: - Events

private extension FavoritesView {}

// MARK: - Preview

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            FavoritesView()
                .preferredColorScheme(scheme)
        }
    }
}
