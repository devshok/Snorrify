import SwiftUI
import SFUIKit

struct AdverbView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: AdverbViewModel
    
    // MARK: - Initialization
    
    init(viewModel: AdverbViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.background(when: colorScheme)
                .ignoresSafeArea()
            
            if viewModel.noData {
                VStack {
                    SFTextPlaceholderView(contract: viewModel.noFormsContract)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    SFTableSectionFormView(contract: viewModel.contract)
                }
            }
        }
    }
}

// MARK: - Preview

struct AdverbView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            AdverbView(viewModel: .mock(withData: true))
                .preferredColorScheme(scheme)
        }
    }
}
