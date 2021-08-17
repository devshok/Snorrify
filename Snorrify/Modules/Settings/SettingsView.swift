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
    private var alertActivation: SettingsViewAlertActivation?
    
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
        .alert(item: $alertActivation) { activationType in
            switch activationType {
            case .removeFavoritesList(let subtype):
                return removeFavoritesAlert(subtype)
            case .clearCache:
                return clearCacheAlert
            }
        }
    }
    
    // MARK: - Events
    
    private func listenEvents() {
        viewModel.$alertActivationPublisher
            .assign(to: \.alertActivation, on: self)
            .store(in: &events)
    }
    
    private func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
        alertActivation = nil
        viewModel.alertActivationPublisher = nil
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
    
    func removeFavoritesAlert(_ type: SettingsViewAlertActivation.RemoveFavorites) -> Alert {
        switch type {
        case .question:
            return .init(
                title: Text(viewModel.alertRemoveFavoritesQuestionTitle),
                primaryButton: .destructive(
                    Text(viewModel.yesText).foregroundColor(.red).bold(),
                    action: {
                        viewModel.removeFavoritesList()
                    }
                ),
                secondaryButton: .cancel(Text(viewModel.noText))
            )
        case .confirmation:
            return .init(title: Text(viewModel.alertRemoveFavoritesConfirmationTitle))
        }
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
