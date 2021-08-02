import Foundation
import Combine
import SFNetKit
import SFUIKit

class ResultsViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: ResultsTextManager
    private let model: ResultsModel
    private var events: Set<AnyCancellable> = []
    private let searchingWord: String
    private let sourceData: [SearchItemResponse]
    private var dataFromServer: [SearchItemResponse]?
    
    // MARK: - Property Wrappers
    
    @Published
    var viewState: ResultsViewState = .none
    
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
                return .forms
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
            viewState = .forms
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
    
    // MARK: - Preview / Mock
    
    static var mock: ResultsViewModel {
        return .init(
            textManager: .mock,
            model: .mock,
            data: [.mockA, .mockB]
        )
    }
}
