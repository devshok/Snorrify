import SwiftUI
import SFUIKit
import Combine

struct SearchView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    var colorScheme
    
    @ObservedObject
    private var viewModel: SearchViewModel
    
    @State
    private var events: Set<AnyCancellable> = []
    
    @State
    private var state: SearchViewState = .defaultEmpty
    
    @State
    private var searchingText: String = ""
    
    // MARK: - Initialization
    
    init(viewModel: SearchViewModel = SearchViewModel.mock(state: .defaultEmpty)) {
        self.viewModel = viewModel
        self.state = viewModel.viewState
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                // BACKGROUND:
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                
                VStack {
                    // SEARCH BAR:
                    SearchBarView(
                        text: $searchingText,
                        placeholder: viewModel.searchText.capitalized,
                        delegate: self
                    )
                    .padding(.horizontal, 14)
                    .disableAutocorrection(true)
                    
                    // 2. CONTENT VIEW:
                    CurrentView(state: $state)
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .center)
                        .edgesIgnoringSafeArea(.top)
                        .background(Color.background(when: colorScheme))
                        .navigationBarTitle(viewModel.searchText.capitalized, displayMode: .large)
                }
            }
        }
        .onAppear { listenEvents() }
        .onDisappear { removeEvents() }
    }
}

// MARK: - SearchBarViewDelegate

extension SearchView: SearchBarViewDelegate {
    func searchBarViewDidPressReturnKey() {
        viewModel.search(for: searchingText)
    }
}

// MARK: - Helpers

private extension SearchView {
    @ViewBuilder
    func CurrentView(state: Binding<SearchViewState>) -> some View {
        switch state.wrappedValue {
        case .defaultEmpty:
            SFImageTextPlaceholderView(contract: viewModel.imagePlaceholderContract)
                .padding(.horizontal, 20)
        case .defaultWithLastResults:
            #warning("create rows of favorites list")
            SFLoadingAlertView(text: viewModel.loadingText)
        case .loading:
            SFLoadingAlertView(text: viewModel.loadingText)
        case .noResults:
            SFTextPlaceholderView(contract: viewModel.noResultsPlaceholderContract)
        }
    }
    
    func listenEvents() {
        viewModel.$viewState
            .sink(receiveValue: { state in
                self.state = state
                if case .noResults = self.state {
                    searchingText = ""
                }
            })
            .store(in: &events)
        viewModel.listenEvents()
    }
    
    func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
}

// MARK: - Preview

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            SearchView(viewModel: .mock(state: .defaultEmpty))
                .preferredColorScheme(scheme)
        }
    }
}
