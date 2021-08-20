import SwiftUI
import SFUIKit
import Combine

struct ResultsView: View {
    // MARK: - Environment Objects
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: - Observed Objects
    
    @ObservedObject private var viewModel: ResultsViewModel
    
    // MARK: - State Objects
    
    @State private var state: ResultsViewState = .none
    @State private var events: Set<AnyCancellable> = []
    
    @State private var errorContract: SFTextPlaceholderViewContract = .init(title: "", description: "")
    @State private var optionsContract: SFTableOptionsViewContract = .init(title: "", options: [])
    
    @State private var selectedItem: SearchItemResponse?
    @State private var selectedWordClass: WordClass = .none
    
    @State private var selectedAdjectiveCategory: AdjectiveCategory = .none
    @State private var selectedVerbCategory: VerbViewCategory = .none
    
    @State private var presentDetails: Bool = false
    @State private var faveItem: Bool = false
    
    // MARK: - Initialization
    
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Events
    
    private func listenEvents() {
        listenViewStatePublisher()
        listenSelectedItemPublisher()
        listenFoundWordClassPublisher()
        listenErrorContractPublisher()
        listenOptionsContractPublisher()
        listenSelectedAdjectiveCategoryPublisher()
        listenSelectedVerbCategoryPublisher()
        listenFaveItemPublisher()
    }
    
    private func listenViewStatePublisher() {
        viewModel.$viewStatePublisher
            .assign(to: \.state, on: self)
            .store(in: &events)
    }
    
    private func listenSelectedItemPublisher() {
        viewModel.$selectedItem
            .assign(to: \.selectedItem, on: self)
            .store(in: &events)
    }
    
    private func listenFoundWordClassPublisher() {
        viewModel.$foundWordClass
            .assign(to: \.selectedWordClass, on: self)
            .store(in: &events)
    }
    
    private func listenErrorContractPublisher() {
        viewModel.$errorContractPublisher
            .assign(to: \.errorContract, on: self)
            .store(in: &events)
    }
    
    private func listenOptionsContractPublisher() {
        viewModel.$optionsContractPublisher
            .assign(to: \.optionsContract, on: self)
            .store(in: &events)
    }
    
    private func listenSelectedAdjectiveCategoryPublisher() {
        viewModel.$selectedAdjectiveCategoryPublisher
            .sink(receiveValue: { value in
                selectedAdjectiveCategory = value
                if value != .none {
                    presentDetails = true
                }
            })
            .store(in: &events)
    }
    
    private func listenSelectedVerbCategoryPublisher() {
        viewModel.$selectedVerbCategoryPublisher
            .sink(receiveValue: { value in
                selectedVerbCategory = value
                if value != .none {
                    presentDetails = true
                }
            })
            .store(in: &events)
    }
    
    private func listenFaveItemPublisher() {
        viewModel.$faveItemPublisher
            .assign(to: \.faveItem, on: self)
            .store(in: &events)
    }
    
    private func removeEvents() {
        viewModel.removeEvents()
        events.forEach { $0.cancel() }
        events.removeAll()
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
            .navigationTitle($viewModel.title.wrappedValue)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(viewModel.closeText, action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    FaveButton()
                }
            }
        }
        .sheet(isPresented: $presentDetails) {
            DetailsView()
        }
        .onAppear {
            listenEvents()
            viewModel.listenEvents()
        }
        .onDisappear {
            removeEvents()
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private func CurrentView() -> some View {
        switch state {
        case .options:
            SFTableOptionsView(contract: optionsContract)
        case .loading:
            SFLoadingAlertView(text: viewModel.loadingText)
        case .error:
            SFTextPlaceholderView(contract: errorContract)
        case .empty:
            SFTextPlaceholderView(contract: viewModel.emptyContract)
        case .noun:
            viewModel.buildNounModule(data: selectedItem)
        case .verb:
            SFTableOptionsView(contract: viewModel.verbOptionsContract)
        case .adjective:
            SFTableOptionsView(contract: viewModel.adjectiveOptionsContract)
        case .numeral:
            viewModel.buildNumeralModule(data: selectedItem)
        case .personalPronoun:
            viewModel.buildPersonalPronounModule(data: selectedItem)
                .padding(.horizontal, -14)
        case .reflexivePronoun:
            viewModel.buildReflexivePronounModule(data: selectedItem)
                .padding(.horizontal, -14)
        case .adverb:
            viewModel.buildAdverbModule(data: selectedItem)
                .padding(.horizontal, -14)
        case .ordinal:
            viewModel.buildOrdinalModule(data: selectedItem)
                .padding(.horizontal, -14)
        case .otherPronoun:
            viewModel.buildOtherPronounModule(data: selectedItem)
                .padding(.horizontal, -14)
        case .none:
            SFTextPlaceholderView(contract: viewModel.noneContract)
        }
    }
    
    @ViewBuilder
    private func DetailsView() -> some View {
        switch selectedWordClass {
        case .verb:
            viewModel.buildVerbModule(category: selectedVerbCategory,
                                      data: selectedItem)
        case .adjective:
            viewModel.buildAdjectiveModule(category: selectedAdjectiveCategory,
                                           data: selectedItem)
        default:
            NavigationView {
                SFTextPlaceholderView(
                    contract: .init(
                        title: "Implement!",
                        description: "This shit is not ready yet for \(selectedWordClass.rawValue)!"
                    )
                )
                .navigationTitle($viewModel.title.wrappedValue)
            }
        }
    }
    
    @ViewBuilder
    private func FaveButton() -> some View {
        switch state.favorable {
        case true:
            Button(action: {
                switch faveItem {
                case true:
                    viewModel.unfave(item: selectedItem)
                case false:
                    viewModel.fave(item: selectedItem)
                }
            }, label: {
                Image(systemName: faveItem ? "star.fill" : "star")
                    .accentColor(.yellow)
                    .foregroundColor(.yellow)
            })
            .accentColor(.yellow)
            .foregroundColor(.yellow)
        case false:
            EmptyView()
        }
    }
}

// MARK: - Preview

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            ResultsView(viewModel: .mock(withData: true))
                .preferredColorScheme(scheme)
        }
    }
}
