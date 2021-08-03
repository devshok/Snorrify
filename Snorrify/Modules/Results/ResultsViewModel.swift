import Foundation
import Combine
import SFNetKit
import SFUIKit
import SwiftUI

class ResultsViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: ResultsTextManager
    private let model: ResultsModel
    private var events: Set<AnyCancellable> = []
    private let searchingWord: String
    private let sourceData: [SearchItemResponse]
    private var dataFromServer: [SearchItemResponse]?
    private var selectedVerbCategory: VerbViewCategory?
    
    // MARK: - Property Wrappers
    
    @Published
    var viewState: ResultsViewState = .none
    
    @Published
    var showVerb: Bool = false
    
    // MARK: - Life Cycle
    
    init(textManager: ResultsTextManager,
         model: ResultsModel,
         data: [SearchItemResponse]
    ) {
        self.textManager = textManager
        self.model = model
        self.searchingWord = data.first?.word ?? ""
        self.sourceData = data
        self.viewState = {
            switch data.count {
            case .zero:
                let contract = SFTextPlaceholderViewContract(
                    title: textManager.empty,
                    description: ""
                )
                return .error(contract)
            case 1:
                return viewState(by: data.first)
            default:
                let contract: SFTableOptionsViewContract = {
                    let options = data.map {
                        $0.toCellOptionViewContract(onTap: { [weak self] id in
                            self?.handleTappedOption(with: id)
                        })
                    }
                    return .init(title: textManager.whichOne, options: options)
                }()
                return .options(contract)
            }
        }()
    }
    
    deinit {
        events.forEach { $0.cancel() }
        events.removeAll()
    }
    
    // MARK: - Subscribers
    
    func listenEvents() {
        model.$noSearchResults
            .sink(receiveValue: { [weak self] noResults in
                if noResults {
                    self?.viewState = .noResults
                }
            })
            .store(in: &events)
        
        model.$requestResult
            .sink(receiveValue: { [weak self] result in
                self?.handleRequestResult(result)
            })
            .store(in: &events)
        
        model.$searching
            .sink(receiveValue: { [weak self] isSearching in
                if isSearching {
                    self?.viewState = .loading
                }
            })
            .store(in: &events)
    }
    
    // MARK: - For Subviews
    
    var title: String {
        searchingWord
    }
    
    var whichOneText: String {
        textManager.whichOne
    }
    
    var emptyText: String {
        textManager.empty
    }
    
    var closeText: String {
        textManager.close.capitalized
    }
    
    var loadingText: String {
        textManager.loading
    }
    
    var noResultsPlaceholderContract: SFTextPlaceholderViewContract {
        let title = textManager.noResultsPlaceholderTitle
        let description: String = {
            switch searchingWord.isEmpty {
            case true:
                return textManager.noResultsPlaceholderDefaultDescription
            case false:
                return textManager.noResultsPlaceholderDescription(for: searchingWord)
            }
        }()
        return .init(title: title, description: description)
    }
    
    func buildNounModule() -> NounView {
        let textManager = NounTextManager()
        let data: SearchItemResponse? = {
            if let someData = dataFromServer {
                return someData.first
            }
            return sourceData.first
        }()
        let viewModel = NounViewModel(data: data, textManager: textManager)
        return .init(viewModel: viewModel)
    }
    
    // MARK: - Handlers
    
    private func handleRequestResult(
        _ result: Published<Result<[SearchItemResponse], NetworkError>?>.Publisher.Output
    ) {
        switch result {
        case .success(let searchResults):
            dataFromServer = searchResults
            handle(newData: searchResults)
        case .failure(let networkError):
            handle(newError: networkError)
        case .none:
            break
        }
    }
    
    private func handle(newData data: [SearchItemResponse]) {
        switch data.count {
        case .zero:
            let contract = SFTextPlaceholderViewContract(
                title: textManager.error,
                description: NetworkError.badResponse.localized
            )
            viewState = .error(contract)
        case 1:
            viewState = viewState(by: data.first)
        default:
            let title = textManager.whichOne
            let options = data.map {
                $0.toCellOptionViewContract(onTap: { [weak self] id in
                    self?.handleTappedOption(with: id)
                })
            }
            let contract = SFTableOptionsViewContract(title: title, options: options)
            viewState = .options(contract)
        }
    }
    
    private func handle(newError error: NetworkError) {
        let contract = SFTextPlaceholderViewContract(
            title: textManager.error,
            description: error.localized
        )
        viewState = .error(contract)
    }
    
    fileprivate func handleTappedOption(with id: String) {
        guard case .options = viewState else {
            debugPrint(self, #function, #line)
            return
        }
        guard let tappedOption = sourceData.first(where: { $0.id == id }) else {
            debugPrint(self, #function, #line)
            return
        }
        model.searchWord(with: tappedOption.id)
    }
    
    private func viewState(by response: SearchItemResponse?) -> ResultsViewState {
        #warning("Complete opening forms for other word classes.")
        switch response?.wordClass {
        case .noun:
            return .noun
        case .verb:
            return .verbCategories(verbCategoriesContract)
        default:
            return .noResults
        }
    }
    
    private var verbCategoriesContract: SFTableOptionsViewContract {
        let title = textManager.chooseCategory
        return .init(title: title, options: verbCategoriesOptionsContract)
    }
    
    private var verbCategoriesOptionsContract: [SFCellOptionViewContract] {
        return [
            verbCategoryOptionContract(for: .voice(.active)),
            verbCategoryOptionContract(for: .voice(.middle)),
            verbCategoryOptionContract(for: .imperativeMood),
            verbCategoryOptionContract(for: .supine),
            verbCategoryOptionContract(for: .participle(.present)),
            verbCategoryOptionContract(for: .participle(.past))
        ]
    }
    
    private func verbCategoryOptionContract(for category: VerbViewCategory) -> SFCellOptionViewContract {
        let id = category.id
        let title = textManager.title(for: category).capitalized
        let subtitle = textManager.title(for: category, translated: true)
        return .init(id: id, title: title, subtitle: subtitle, action: { [weak self] _ in
            self?.selectedVerbCategory = category
            self?.showVerb = true
        })
    }
    
    // MARK: - Preview / Mock
    
    static var mock: ResultsViewModel {
        return .init(
            textManager: .mock,
            model: .mock,
            data: [.mockA, .mockB]
        )
    }
}
