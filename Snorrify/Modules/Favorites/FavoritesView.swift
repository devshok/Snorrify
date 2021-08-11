import SwiftUI
import SFUIKit
import Combine

struct FavoritesView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    // MARK: - Observed Objects
    
    @ObservedObject
    private var viewModel: FavoritesViewModel
    
    // MARK: - State Objects
    
    @State
    private var state: FavoritesViewState = .none
    
    @State
    private var searchingText: String = ""
    
    @State
    private var showErrorAlert: Bool = false
    
    @State
    private var errorAlertTitle: String = ""
    
    @State
    private var errorAlertDescription: String = ""
    
    @State
    private var favorites: [SFCellFaveViewContract] = []
    
    @State
    private var presentDetails: Bool = false
    
    @State
    private var selectedItem: SearchItemResponse?
    
    @State
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                
                CurrentView()
                    .padding(.horizontal, 14)
            }
            .navigationTitle(viewModel.title)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(errorAlertTitle),
                message: Text(errorAlertDescription),
                dismissButton: .cancel(Text(viewModel.okText))
            )
        }
        .sheet(isPresented: $presentDetails) {
            viewModel.buildResultsModule(selectedItem: selectedItem)
        }
        .onAppear { listenEvents() }
    }
}

// MARK: - Current View

private extension FavoritesView {
    @ViewBuilder
    func CurrentView() -> some View {
        switch state {
        case .empty:
            SFImageTextPlaceholderView(contract: viewModel.emptyContract)
        case .hasContent:
            DataContainer()
        case .none:
            SFTextPlaceholderView(contract: viewModel.noneContract)
        }
    }
    
    @ViewBuilder
    private func DataContainer() -> some View {
        VStack(spacing: 14) {
            SearchBarView(text: $searchingText, placeholder: viewModel.searchPlaceholder, delegate: self)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            switch favorites.isEmpty {
            case true:
                ContainerWithoutData()
            case false:
                ContainerWithData()
            }
        }
    }
    
    @ViewBuilder
    private func ContainerWithData() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            Group {
                ForEach(favorites) { contract in
                    SFCellFaveView(contract: contract)
                        .onTapGesture {
                            viewModel.select(faveId: contract.id)
                            presentDetails.toggle()
                        }
                }
            }
        }
        .gesture(
            DragGesture().onChanged { _ in
                viewModel.hideKeyboard()
            }
        )
        .onTapGesture {
            viewModel.hideKeyboard()
        }
    }
    
    @ViewBuilder
    private func ContainerWithoutData() -> some View {
        VStack(spacing: .zero) {
            Spacer()
            SFTextPlaceholderView(contract: viewModel.noSearchResultsContract)
            Spacer()
        }
        .onTapGesture {
            viewModel.hideKeyboard()
        }
    }
}

// MARK: - Events

private extension FavoritesView {
    func listenEvents() {
        listenViewStatePublisher()
        listenErrorAlertPublishers()
        listenFavoritesPublisher()
        listenSelectedItemPublisher()
    }
    
    // view state:
    
    private func listenViewStatePublisher() {
        viewModel.$viewState
            .assign(to: \.state, on: self)
            .store(in: &events)
        state = viewModel.viewState
    }
    
    // alert:
    
    private func listenErrorAlertPublishers() {
        listenErrorAlertTitlePublisher()
        listenErrorAlertDescriptionPublisher()
        listenShowErrorAlertPublisher()
    }
    
    private func listenErrorAlertTitlePublisher() {
        viewModel.$errorAlertTitle
            .assign(to: \.errorAlertTitle, on: self)
            .store(in: &events)
    }
    
    private func listenErrorAlertDescriptionPublisher() {
        viewModel.$errorAlertDescription
            .assign(to: \.errorAlertDescription, on: self)
            .store(in: &events)
    }
    
    private func listenShowErrorAlertPublisher() {
        viewModel.$showErrorAlert
            .assign(to: \.showErrorAlert, on: self)
            .store(in: &events)
    }
    
    // selected item to present:
    
    private func listenSelectedItemPublisher() {
        viewModel.$selectedItemPublisher
            .assign(to: \.selectedItem, on: self)
            .store(in: &events)
    }
    
    // favorites:
    
    private func listenFavoritesPublisher() {
        viewModel.$favoritesPublisher
            .assign(to: \.favorites, on: self)
            .store(in: &events)
    }
}

// MARK: - SearchBarViewDelegate

extension FavoritesView: SearchBarViewDelegate {
    func searchBarViewDidPressReturnKey() {
        viewModel.search(for: searchingText)
    }
    
    func searchBarViewDidTypeText(_ text: String) {
        viewModel.search(for: text)
    }
}

// MARK: - Preview

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            FavoritesView(viewModel: .mock(state: .empty))
                .preferredColorScheme(scheme)
        }
    }
}
