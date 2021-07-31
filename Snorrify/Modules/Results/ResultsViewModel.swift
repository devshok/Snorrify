import Foundation
import Combine
import SFNetKit

class ResultsViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: ResultsTextManager
    private let model: ResultsModel
    private var events: Set<AnyCancellable> = []
    private let searchingWord: String
    
    // MARK: - Property Wrappers
    
    @Published
    var viewState: ResultsViewState
    
    // MARK: - Life Cycle
    
    init(viewState: ResultsViewState,
         textManager: ResultsTextManager,
         model: ResultsModel,
         data: [SearchItemResponse]
    ) {
        self.viewState = viewState
        self.textManager = textManager
        self.model = model
        self.searchingWord = data.first?.word ?? ""
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
        searchingWord.capitalized
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
        #warning("Implement handle request result in ResultsViewModel.")
    }
    
    // MARK: - Preview / Mock
    
    static var mock: ResultsViewModel {
        return .init(
            viewState: .none,
            textManager: .mock,
            model: .mock,
            data: []
        )
    }
}
