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
    
    @State
    private var showResults = false
    
    @State
    private var subscribedEvents = false
    
    // MARK: - Life Cycle
    
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
                    .autocapitalization(.none)
                    
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
            .onTapGesture {
                viewModel.hideKeyboard()
            }
        }
        .navigationBarTitle(viewModel.searchText)
        .onAppear { listenEvents() }
        .sheet(isPresented: $showResults) {
            viewModel.buildResultsModule()
        }
    }
}

// MARK: - SearchBarViewDelegate

extension SearchView: SearchBarViewDelegate {
    func searchBarViewDidPressReturnKey() {
        viewModel.search(for: searchingText)
    }
    
    func searchBarViewDidTypeText(_ text: String) {
        debugPrint("SearchView", #function, text)
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
        case let .error(title, description):
            let contract = SFTextPlaceholderViewContract(
                title: title,
                description: description
            )
            SFTextPlaceholderView(contract: contract)
                .padding(.horizontal, 14)
        }
    }
    
    func listenEvents() {
        defer {
            viewModel.listenEvents()
            subscribedEvents = true
        }
        guard !subscribedEvents else { return }
        viewModel.$viewState
            .sink(receiveValue: { state in
                self.state = state
                if case .loading = self.state {
                    searchingText = ""
                }
            })
            .store(in: &events)
        viewModel.$showResults
            .assign(to: \.showResults, on: self)
            .store(in: &events)
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
