import SwiftUI
import SFUIKit

struct MainView: View {
    // MARK: - Properties
    
    @Environment(\.colorScheme) var colorScheme
    private let viewModel: MainViewModel
    
    // MARK: - Initialization
    
    init(viewModel: MainViewModel = MainViewModelImpl.mock) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label(
                        title: {
                            Text(viewModel.tabTitle(for: .search))
                        },
                        icon: {
                            Image(uiImage: (.sfMainViewSearchTab ?? .init()))
                        }
                    )
                }
            
            FavoritesView()
                .tabItem {
                    Label(
                        title: {
                            Text(viewModel.tabTitle(for: .favorites))
                        },
                        icon: {
                            Image(uiImage: (.sfMainViewFavoritesTab ?? .init()))
                        }
                    )
                }
            
            SettingsView()
                .tabItem {
                    Label(
                        title: {
                            Text(viewModel.tabTitle(for: .settings))
                        },
                        icon: {
                            Image(uiImage: (.sfMainViewSettingsTab ?? .init()))
                        }
                    )
                }
        }
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            MainView()
                .preferredColorScheme(scheme)
        }
    }
}
