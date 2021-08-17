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
    private var currentState: SearchViewState = .defaultEmpty {
        willSet {
            if case .readyToShowResults = newValue, didTapSearch {
                sheetActivation = .results
                didTapSearch.toggle()
            }
        }
        didSet {
            previousState = oldValue
        }
    }
    
    @State
    private var previousState: SearchViewState = .none {
        willSet {
            if case .readyToShowResults = currentState {
                currentState = newValue
            }
        }
    }
    
    @State
    private var didTapSearch: Bool = false
    
    @State
    private var searchingText: String = ""
    
    @State
    private var sheetActivation: SearchViewSheetActivation?
    
    // MARK: - Life Cycle
    
    init(viewModel: SearchViewModel = SearchViewModel.mock(state: .defaultEmpty)) {
        self.viewModel = viewModel
        self.currentState = viewModel.viewState
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
                    CurrentView(state: $currentState)
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
            .sheet(item: $sheetActivation) { value in
                switch value {
                case .results:
                    viewModel.buildSearchResultsModule()
                case .history:
                    viewModel.buildHistoryModule()
                }
            }
            .navigationBarTitle(viewModel.searchText)
        }
        .onAppear { listenEvents() }
    }
}

// MARK: - SearchBarViewDelegate

extension SearchView: SearchBarViewDelegate {
    func searchBarViewDidPressReturnKey() {
        didTapSearch.toggle()
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
            ScrollView(.vertical, showsIndicators: false) {
                SFCellBoldHeaderView(text: viewModel.lastResultsText)
                    .padding(.bottom, -14)
                    .padding(.top, 14)
                Group {
                    ForEach(viewModel.history, id: \.self) { contract in
                        SFCellFaveView(contract: contract)
                            .onTapGesture {
                                viewModel.select(historyId: contract.id)
                                sheetActivation = .history
                            }
                    }
                }
            }
            .padding(.horizontal, 14)
        case .loading:
            SFLoadingAlertView(text: viewModel.loadingText)
        case .noResults:
            SFTextPlaceholderView(contract: viewModel.noResultsPlaceholderContract)
        case .error:
            SFTextPlaceholderView(contract: viewModel.errorContract)
                .padding(.horizontal, 14)
        case .readyToShowResults, .none:
            EmptyView()
        }
    }
    
    func listenEvents() {
        defer {
            viewModel.listenEvents()
        }
        viewModel.$viewState
            .sink(receiveValue: { state in
                self.currentState = state
                if case .loading = self.currentState {
                    searchingText = ""
                }
            })
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
