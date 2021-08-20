import SwiftUI
import SFUIKit

struct ReflexivePronounView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: ReflexivePronounViewModel
    
    // MARK: - Initialization
    
    init(viewModel: ReflexivePronounViewModel) {
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

struct ReflexivePronounView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            ReflexivePronounView(viewModel: .mock(withData: true))
                .preferredColorScheme(scheme)
        }
    }
}
