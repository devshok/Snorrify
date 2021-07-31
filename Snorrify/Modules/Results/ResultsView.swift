import SwiftUI
import SFUIKit

struct ResultsView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @State
    private var state: ResultsViewState = .none
    
    @ObservedObject
    private var viewModel: ResultsViewModel
    
    // MARK: - Initialization
    
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                CurrentView(state: $state)
                    .edgesIgnoringSafeArea(.top)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(viewModel.closeText) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle(viewModel.title)
        }
    }
}

// MARK: - Helpers

private extension ResultsView {
    @ViewBuilder
    func CurrentView(state: Binding<ResultsViewState>) -> some View {
        switch state.wrappedValue {
        case .options:
            return SFTextPlaceholderView(contract: .mock)
        case .forms:
            return SFTextPlaceholderView(contract: .mock)
        case .error(let contract):
            return SFTextPlaceholderView(contract: contract)
        case .loading:
            return SFTextPlaceholderView(contract: .mock)
        case .noResults:
            return SFTextPlaceholderView(contract: .mock)
        case .none:
            let contract = SFTextPlaceholderViewContract(
                title: viewModel.emptyText,
                description: ""
            )
            return SFTextPlaceholderView(contract: contract)
        }
    }
}

// MARK: - Preview

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            ResultsView(viewModel: .mock)
                .preferredColorScheme(scheme)
        }
    }
}
