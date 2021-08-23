import SwiftUI
import SFUIKit

struct OtherPronounView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: OtherPronounViewModel
    
    // MARK: - Initialization
    
    init(viewModel: OtherPronounViewModel) {
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
                    ForEach(viewModel.contracts) { contract in
                        SFTableSectionFormView(contract: contract)
                            .padding(.top, 14)
                    }
                }
                .padding(.top, -14)
            }
        }
    }
}

// MARK: - Preview

struct OtherPronounView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            OtherPronounView(viewModel: .mock(withData: true))
                .preferredColorScheme(scheme)
        }
    }
}
