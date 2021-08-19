import Foundation
import SFNetKit
import Combine
import SwiftUI

class SearchModel {
    // MARK: - Properties
    
    private let netKit: NetKit
    private let dbKit: DBKit
    private var subscriber: AnyCancellable?
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Publishers
    
    @Published
    var searching: Bool = false
    
    @Published
    var noSearchResults: Bool = false
    
    @Published
    var lastRequestResult: Result<[SearchItemResponse], NetworkError>?
    
    @Published
    var historySearchResults: [DBSearchItemResponse] = []
    
    // MARK: - Life Cycle
    
    required init(netKit: NetKit, dbKit: DBKit) {
        self.netKit = netKit
        self.dbKit = dbKit
        self.listenEvents()
    }
    
    deinit {
        removeEvents()
    }
    
    // MARK: - Events
    
    private func listenEvents() {
        dbKit.$searchResults
            .assign(to: \.historySearchResults, on: self)
            .store(in: &events)
    }
    
    private func removeEvents() {
        events.forEach { $0.cancel() }
        events.removeAll()
        subscriber?.cancel()
        subscriber = nil
    }
    
    // MARK: - API
    
    func search(word text: String) {
        let word = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !word.isEmpty else { return }
        guard !searching else { return }
        noSearchResults = false
        searching = true
        lastRequestResult = nil
        subscriber = netKit.request(path: .word(word))
            .sink(receiveCompletion: { [weak self] completion in
                self?.searching = false
                if case .failure(let networkError) = completion {
                    self?.lastRequestResult = .failure(networkError)
                    if case .noSearchResults = networkError {
                        self?.noSearchResults = true
                    }
                }
            }, receiveValue: { [weak self] searchResultsResponse in
                self?.lastRequestResult = .success(searchResultsResponse)
            })
    }
    
    func buildResultsModule(data: [SearchItemResponse]) -> ResultsView {
        resultsModel.reset(data: data)
        return .init(viewModel: resultsViewModel)
    }
    
    func addToHistory(item: SearchItemResponse?) {
        let searchResult = DBSearchItemResponse(item: item)
        dbKit.add(searchResult: searchResult)
    }
    
    func fave(item: DBSearchItemResponse?) {
        let favorite = DBFaveItemResponse(item: item?.item)
        dbKit.add(favorite: favorite)
    }
    
    func unfave(item: DBSearchItemResponse?) {
        let favorite = DBFaveItemResponse(item: item?.item)
        dbKit.remove(favorite: favorite)
    }
    
    // MARK: - Results Module
    
    private lazy var resultsTextManager = ResultsTextManager()
    private lazy var resultsModel = ResultsModel(netKit: netKit, dbKit: dbKit, data: [])
    private lazy var resultsViewModel = ResultsViewModel(textManager: resultsTextManager, model: resultsModel)
    
    // MARK: - Mock / Preview
    
    static var mock: Self {
        return .init(netKit: NetKit.default, dbKit: .shared)
    }
}
