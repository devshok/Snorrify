import Foundation
import SFNetKit
import Combine
import SwiftUI

class SearchModel {
    // MARK: - Properties
    
    private let netKit: NetKit
    private let dbKit: DBKit
    private var subscriber: AnyCancellable?
    
    // MARK: - Property Wrappers
    
    @Published
    var searching: Bool = false
    
    @Published
    var noSearchResults: Bool = false
    
    @Published
    var lastRequestResult: Result<[SearchItemResponse], NetworkError>?
    
    // MARK: - Life Cycle
    
    required init(netKit: NetKit, dbKit: DBKit) {
        self.netKit = netKit
        self.dbKit = dbKit
    }
    
    deinit {
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
        let textManager = ResultsTextManager()
        let model = ResultsModel(netKit: netKit, dbKit: dbKit, data: data)
        let viewModel = ResultsViewModel(textManager: textManager, model: model)
        return .init(viewModel: viewModel)
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self {
        return .init(netKit: NetKit.default, dbKit: .shared)
    }
}
