import SwiftUI
import SFUIKit

struct SettingsView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: SettingsViewModel
    
    // MARK: - State Objects
    
    @State
    private var sheetActication: SettingsViewSheetActivation?
    
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
