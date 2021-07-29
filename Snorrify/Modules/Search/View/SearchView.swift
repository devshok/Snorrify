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
    var state: SearchViewState = .defaultEmpty
    
    // MARK: - Initialization
    
    init(viewModel: SearchViewModel = SearchViewModel.mock(state: .defaultEmpty)) {
        self.viewModel = viewModel
        listenEvents()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                CurrentView(state: state)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .ignoresSafeArea()
                    .background(Color.background(when: colorScheme))
                    .onAppear { listenEvents() }
                    .onDisappear { removeEvents() }
                    .navigationBarTitle(viewModel.searchText.capitalized, displayMode: .large)
            }
        }
    }
}

// MARK: - Helpers

private extension SearchView {
    @ViewBuilder
    func CurrentView(state: SearchViewState) -> some View {
        switch state {
        case .defaultEmpty:
            SFImageTextPlaceholderView(contract: viewModel.placeholderContract)
                .padding(.horizontal, 20)
        case .defaultWithLastResults:
            SFLoadingAlertView(text: viewModel.loadingText)
        case .loading:
            SFLoadingAlertView(text: viewModel.loadingText)
        case .noResults:
            SFLoadingAlertView(text: viewModel.loadingText)
        }
    }
    
    func listenEvents() {
        state = viewModel.viewState
        viewModel.$viewState
            .assign(to: \.state, on: self)
            .store(in: &events)
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
