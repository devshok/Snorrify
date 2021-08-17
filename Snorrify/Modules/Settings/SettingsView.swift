import SwiftUI
import SFUIKit
import Combine

struct SettingsView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: SettingsViewModel
    
    // MARK: - State Objects
    
    @State
    private var sheetActivation: SettingsViewSheetActivation?
    
    @State
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        SFTableSettingsSectionView(contract: viewModel.cacheContract)
                        SFTableSettingsSectionView(contract: viewModel.dataContract)
                        SFTableSettingsSectionView(contract: viewModel.feedbackContract)
                    }
                }
            }
            .navigationBarTitle(viewModel.title)
        }
        .onAppear { listenEvents() }
        .onDisappear { removeEvents() }
        .alert(item: $sheetActivation) { value in
            switch value {
            case .removeFavoritesList:
                return removeFavoritesAlert
            case .clearCache:
                return clearCacheAlert
            }
        }
    }
    
    // MARK: - Events
    
    private func listenEvents() {
        viewModel.$sheetActivationPublisher
            .assign(to: \.sheetActivation, on: self)
            .store(in: &events)
    }
    
    private func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - Alerts
    
    var clearCacheAlert: Alert {
        .init(
            title: Text(viewModel.alertRemoveCacheTitle),
            primaryButton: .destructive(
                Text(viewModel.yesText).foregroundColor(.red).bold(),
                action: {
                    viewModel.clearCache()
                }
            ),
            secondaryButton: .cancel(Text(viewModel.noText))
        )
    }
    
    var removeFavoritesAlert: Alert {
        .init(
            title: Text(viewModel.alertRemoveFavoritesTitle),
            primaryButton: .destructive(
                Text(viewModel.yesText).foregroundColor(.red).bold(),
                action: {
                    viewModel.removeFavoritesList()
                }
            ),
            secondaryButton: .cancel(Text(viewModel.noText))
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            SettingsView(viewModel: .mock)
                .preferredColorScheme(scheme)
        }
    }
}
