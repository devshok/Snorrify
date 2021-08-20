import SwiftUI
import SFUIKit

struct PersonalPronounView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: PersonalPronounViewModel
    
    // MARK: - Initialization
    
    init(viewModel: PersonalPronounViewModel) {
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

struct PersonalPronounView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            PersonalPronounView(viewModel: .mock(withData: true))
                .preferredColorScheme(scheme)
        }
    }
}
