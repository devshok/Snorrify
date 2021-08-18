import SwiftUI
import Combine
import SFNetKit
import SFUIKit

class ResultsViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: ResultsTextManager
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Observed Objects
    
    @ObservedObject
    private var model: ResultsModel
    
    // MARK: - Publishers
    
    @Published
    var viewStatePublisher: ResultsViewState = .none
    
    @Published
    var selectedItem: SearchItemResponse?
    
    @Published
    var foundWordClass: WordClass = .none
    
    @Published
    var errorContractPublisher: SFTextPlaceholderViewContract = .init(title: "", description: "")
    
    @Published
    var optionsContractPublisher: SFTableOptionsViewContract = .init(title: "", options: [])
    
    @Published
    var selectedAdjectiveCategoryPublisher: AdjectiveCategory = .none
    
    @Published
    var selectedVerbCategoryPublisher: VerbViewCategory = .none
    
    @Published
    var faveItemPublisher: Bool = false
    
    // MARK: - Life Cycle
    
    init(textManager: ResultsTextManager, model: ResultsModel) {
        self.textManager = textManager
        self.model = model
    }
    
    deinit {
        removeEvents()
        debugPrint(self, #function, #line)
    }
    
    // MARK: - Events
    
    func listenEvents() {
        listenDataPublisher()
        listenErrorPublisher()
        listenLoadingPublisher()
    }
    
    private func listenDataPublisher() {
        model.$dataPublisher
            .sink(receiveValue: { [weak self] value in
                self?.handleNewData(value)
            })
            .store(in: &events)
    }
    
    private func listenErrorPublisher() {
        model.$errorPublisher
            .sink(receiveValue: { [weak self] value in
                self?.handleNewError(value)
            })
            .store(in: &events)
    }
    
    private func listenLoadingPublisher() {
        model.$loadingPublisher
            .sink(receiveValue: { [weak self] value in
                self?.handleNewLoading(value)
            })
            .store(in: &events)
    }
    
    private func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - View Strings
    
    var titleText: String {
        model.word ?? .emptyFormString
    }
    
    var closeText: String {
        textManager.close.capitalized
    }
    
    var loadingText: String {
        textManager.loading.capitalized
    }
    
    func nounTabTitle(at article: DefiniteArticle) -> String {
        switch article {
        case .no:
            return textManager.indefiniteArticle.capitalized
        case .yes:
            return textManager.definiteArticle.capitalized
        }
    }
    
    // MARK: - View Actions
    
    func buildNounModule(data: SearchItemResponse?) -> NounView {
        let textManager = NounTextManager()
        let viewModel = NounViewModel(data: data, textManager: textManager)
        return .init(viewModel: viewModel)
    }
    
    func buildVerbModule(category: VerbViewCategory,
                         data: SearchItemResponse?) -> VerbView {
        let textManager = VerbTextManager()
        let model = VerbModel(data: data)
        let viewModel = VerbViewModel(category: category,
                                      textManager: textManager,
                                      model: model)
        return .init(viewModel: viewModel)
    }
    
    func buildAdjectiveModule(category: AdjectiveCategory,
                              data: SearchItemResponse?) -> AdjectiveView {
        let textManager = AdjectiveTextManager()
        let model = AdjectiveModel(data: data)
        let viewModel = AdjectiveViewModel(adjectiveCategory: category,
                                           textManager: textManager,
                                           model: model)
        return .init(viewModel: viewModel)
    }
    
    func fave(item: SearchItemResponse?) {
        model.fave(item: item)
        faveItemPublisher = model.isFave(item: item)
    }
    
    func unfave(item: SearchItemResponse?) {
        model.unfave(item: item)
        faveItemPublisher = model.isFave(item: item)
    }
    
    // MARK: - Model Values
    
    private func handleNewData(_ value: [SearchItemResponse]) {
        withAnimation(.spring()) {
            switch value.count {
            case 0:
                viewStatePublisher = .empty
            case 1:
                handleNewSingleData(value.first!)
            default:
                optionsContractPublisher = tableOptionsContract(by: value)
                viewStatePublisher = .options
            }
        }
    }
    
    private func handleNewSingleData(_ value: SearchItemResponse) {
        defer {
            if viewStatePublisher.favorable {
                faveItemPublisher = model.isFave(item: selectedItem)
            }
            #warning("Bug happens here!")
            model.addToHistory(item: value)
        }
        selectedItem = value
        foundWordClass = value.wordClass
        switch value.wordClass {
        case .noun:
            viewStatePublisher = .noun
        case .adjective:
            viewStatePublisher = .adjective
        case .verb:
            viewStatePublisher = .verb
        default:
            viewStatePublisher = .none
        }
    }
    
    private func handleNewError(_ value: NetworkError) {
        guard value != .none else { return }
        let title = textManager.error.capitalized
        let description = value.localized
        let contract = SFTextPlaceholderViewContract(title: title, description: description)
        errorContractPublisher = contract
        viewStatePublisher = .error
    }
    
    private func handleNewLoading(_ value: Bool) {
        if value {
            viewStatePublisher = .loading
        }
    }
    
    // MARK: - General Contracts
    
    var noneContract: SFTextPlaceholderViewContract {
        let title = textManager.empty.capitalized
        let description = textManager.errorUnknownReasonDescription
            .capitalizedOnlyFirstLetter
        return .init(title: title, description: description)
    }
    
    var emptyContract: SFTextPlaceholderViewContract {
        let title = textManager.noResults.capitalized
        return .init(title: title, description: "")
    }
    
    // MARK: - Options' Contracts
    
    private func tableOptionsContract(by data: [SearchItemResponse]) -> SFTableOptionsViewContract {
        let title = textManager.whichOne.capitalizedOnlyFirstLetter
        let options = optionsContracts(by: data)
        return .init(title: title, options: options)
    }
    
    private func optionsContracts(by data: [SearchItemResponse]) -> [SFCellOptionViewContract] {
        return data.map { item in
            let wordClass = item.wordClass
            let gender = item.gender
            let subtitle = textManager.optionSubtitle(for: wordClass, gender: gender)
            return .init(id: item.id,
                         title: item.word,
                         subtitle: subtitle,
                         action: { [weak self] optionId in
                self?.model.loadForms(for: optionId)
            })
        }
    }
    
    // MARK: - Adjectives' Contracts
    
    var adjectiveOptionsContract: SFTableOptionsViewContract {
        let title = textManager.chooseCategory.capitalizedOnlyFirstLetter
        return .init(title: title, options: adjectivesOptionsContracts)
    }
    
    private var adjectivesOptionsContracts: [SFCellOptionViewContract] {
        [
            .init(
                id: AdjectiveDegree.positive.rawValue,
                title: textManager.degree(.positive, translated: false).capitalized,
                subtitle: textManager.degree(.positive, translated: true),
                action: { [weak self] _ in
                    self?.selectedAdjectiveCategoryPublisher = .positiveDegree
                }
            ),
            .init(
                id: AdjectiveDegree.comparative.rawValue,
                title: textManager.degree(.comparative, translated: false).capitalized,
                subtitle: textManager.degree(.comparative, translated: true),
                action: { [weak self] _ in
                    self?.selectedAdjectiveCategoryPublisher = .comparativeDegree
                }
            ),
            .init(
                id: AdjectiveDegree.superlative.rawValue,
                title: textManager.degree(.superlative, translated: false).capitalized,
                subtitle: textManager.degree(.superlative, translated: true),
                action: { [weak self] _ in
                    self?.selectedAdjectiveCategoryPublisher = .superlativeDegree
                }
            )
        ]
    }
    
    // MARK: - Verbs' Contracts
    
    var verbOptionsContract: SFTableOptionsViewContract {
        let title = textManager.chooseCategory.capitalizedOnlyFirstLetter
        return .init(title: title, options: verbOptionsContracts)
    }
    
    private var verbOptionsContracts: [SFCellOptionViewContract] {
        [
            .init(
                id: String(1),
                title: textManager.verbVoice(.active, translated: false).capitalized,
                subtitle: textManager.verbVoice(.active, translated: true).capitalized,
                action: { [weak self] id in
                    self?.selectedVerbCategoryPublisher = .voice(.active)
                }
            ),
            .init(
                id: String(2),
                title: textManager.verbVoice(.middle, translated: false).capitalized,
                subtitle: textManager.verbVoice(.middle, translated: true).capitalized,
                action: { [weak self] _ in
                    self?.selectedVerbCategoryPublisher = .voice(.middle)
                }
            ),
            .init(
                id: String(3),
                title: textManager.imperativeMood(translated: false).capitalized,
                subtitle: textManager.imperativeMood(translated: true).capitalized,
                action: { [weak self] _ in
                    self?.selectedVerbCategoryPublisher = .imperativeMood
                }
            ),
            .init(
                id: String(4),
                title: textManager.supine(translated: false).capitalized,
                subtitle: textManager.supine(translated: true).capitalized,
                action: { [weak self] _ in
                    self?.selectedVerbCategoryPublisher = .supine
                }
            ),
            .init(
                id: String(5),
                title: textManager.participle(
                    tense: .present,
                    translated: false
                ).capitalizedOnlyFirstLetter,
                subtitle: textManager.participle(tense: .present, translated: true),
                action: { [weak self] _ in
                    self?.selectedVerbCategoryPublisher = .participle(.present)
                }
            ),
            .init(
                id: String(6),
                title: textManager.participle(
                    tense: .past,
                    translated: false
                ).capitalizedOnlyFirstLetter,
                subtitle: textManager.participle(tense: .past, translated: true),
                action: { [weak self] _ in
                    self?.selectedVerbCategoryPublisher = .participle(.past)
                }
            )
        ]
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> ResultsViewModel {
        let model = ResultsModel.mock(withData: withData)
        let textManager = ResultsTextManager.mock
        return .init(textManager: textManager, model: model)
    }
}
