import SwiftUI
import SFUIKit
import Combine

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
    
    @State
    private var events: Set<AnyCancellable> = []
    
    @State
    private var subscribedEvents: Bool = false
    
    // MARK: - Initialization
    
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.viewState
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                CurrentView(state: $state)
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
        .onAppear { listenEvents() }
        .sheet(isPresented: $viewModel.showForms) {
            viewModel.buildVerbModule()
        }
    }
}

// MARK: - Helpers

private extension ResultsView {
    @ViewBuilder
    func CurrentView(state: Binding<ResultsViewState>) -> some View {
        switch state.wrappedValue {
        case .options(let contract):
            SFTableOptionsView(contract: contract)
                .padding(.horizontal, 14)
                .padding(.top, 14)
        case .noun:
            viewModel.buildNounModule()
        case .error(let contract):
            SFTextPlaceholderView(contract: contract)
                .padding(.horizontal, 14)
        case .verbCategories(let contract):
            ScrollView(.vertical, showsIndicators: false) {
                SFTableOptionsView(contract: contract)
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)
        case .loading:
            SFLoadingAlertView(text: viewModel.loadingText)
        case .noResults:
            SFTextPlaceholderView(contract: viewModel.noResultsPlaceholderContract)
        case .none:
            let contract = SFTextPlaceholderViewContract(
                title: viewModel.emptyText,
                description: ""
            )
            SFTextPlaceholderView(contract: contract)
        }
    }
    
    @ViewBuilder
    func FormsView() -> some View {
        if viewModel.selectedWordClass == .none {
            SFTextPlaceholderView(
                contract: viewModel.unknownErrorPlaceholderContract
            ).padding(.horizontal, 14)
        } else {
            switch viewModel.selectedWordClass {
            case .verb:
                viewModel.buildVerbModule()
            default:
                SFTextPlaceholderView(
                    contract: viewModel.unknownErrorPlaceholderContract
                ).padding(.horizontal, 14)
            }
        }
    }
    
    func listenEvents() {
        guard !subscribedEvents else { return }
        defer {
            viewModel.listenEvents()
            subscribedEvents = true
        }
        viewModel.$viewState
            .assign(to: \.state, on: self)
            .store(in: &events)
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
