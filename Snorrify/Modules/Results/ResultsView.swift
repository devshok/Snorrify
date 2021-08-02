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
    private var state: ResultsViewState = .none {
        didSet {
            print(#function, state)
        }
    }
    
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
        .onAppear { listenEvents() }
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
        case .forms:
            let contract = SFTextPlaceholderViewContract(
                title: "Forms",
                description: "Got some data"
            )
            SFTextPlaceholderView(contract: contract)
        case .error(let contract):
            SFTextPlaceholderView(contract: contract)
                .padding(.horizontal, 14)
        case .loading:
            SFLoadingAlertView(text: viewModel.loadingText)
        case .noResults:
            SFTextPlaceholderView(contract: .mock)
        case .none:
            let contract = SFTextPlaceholderViewContract(
                title: viewModel.emptyText,
                description: ""
            )
            SFTextPlaceholderView(contract: contract)
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
