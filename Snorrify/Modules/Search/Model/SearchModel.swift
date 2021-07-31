import Foundation
import SFNetKit
import Combine
import SwiftUI

class SearchModel {
    private let netKit: NetKit
    private var subscriber: AnyCancellable?
    
    @Published
    var searching: Bool = false
    
    @Published
    var noSearchResults: Bool = false
    
    @Published
    var lastRequestResult: Result<[SearchItemResponse], NetworkError>?
    
    required init(netKit: NetKit) {
        self.netKit = netKit
    }
    
    deinit {
        subscriber?.cancel()
        subscriber = nil
    }
    
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
    
    func buildResultsModule(
        viewState: ResultsViewState,
        data: [SearchItemResponse]
    ) -> ResultsView {
        let model = ResultsModel(netKit: netKit)
        let textManager = ResultsTextManager()
        let viewModel = ResultsViewModel(
            viewState: viewState,
            textManager: textManager,
            model: model,
            data: data
        )
        return ResultsView(viewModel: viewModel)
    }
    
    static var mock: Self {
        return .init(netKit: NetKit.default)
    }
}
