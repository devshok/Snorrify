import SwiftUI
import SFUIKit

struct NumeralView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: NumeralViewModel
    
    // MARK: - State Objects
    
    @State
    private var tabIndex: Int = NumeralViewTab.singular.rawValue
    
    // MARK: - Initialization
    
    init(viewModel: NumeralViewModel) {
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
                VStack(alignment: .center, spacing: 14) {
                    Picker("", selection: $tabIndex) {
                        Text(viewModel.title(for: .singular))
                            .tag(NumeralViewTab.singular.rawValue)
                        Text(viewModel.title(for: .plural))
                            .tag(NumeralViewTab.plural.rawValue)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 14)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        SFTableSectionFormView(
                            contract: viewModel.contract(at: tabIndex)
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct NumeralView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            NumeralView(viewModel: .mock)
                .preferredColorScheme(scheme)
        }
    }
}
