import Foundation
import SFNetKit
import Combine
import SwiftUI

class SearchModel {
    // MARK: - Properties
    
    private let netKit: NetKit
    private var subscriber: AnyCancellable?
    
    // MARK: - Property Wrappers
    
    @Published
    var searching: Bool = false
    
    @Published
    var noSearchResults: Bool = false
    
    @Published
    var lastRequestResult: Result<[SearchItemResponse], NetworkError>?
    
    // MARK: - Life Cycle
    
    required init(netKit: NetKit) {
        self.netKit = netKit
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
    
    // MARK: - Build Results Module
    
    func buildResultsModule(data: [SearchItemResponse]) -> ResultsView {
        let viewModel = resultsViewModel(data: data)
        let view = resultsView(viewModel: viewModel)
        return view
    }
    
    private func resultsView(viewModel: ResultsViewModel) -> ResultsView {
        .init(viewModel: viewModel)
    }
    
    private func resultsViewModel(data: [SearchItemResponse]) -> ResultsViewModel {
        let textManager = resultsTextManager()
        let model = resultsModel()
        return .init(textManager: textManager, model: model, data: data)
    }
    
    private func resultsTextManager() -> ResultsTextManager {
        .init()
    }
    
    private func resultsModel() -> ResultsModel {
        .init(netKit: netKit)
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self {
        return .init(netKit: NetKit.default)
    }
}
