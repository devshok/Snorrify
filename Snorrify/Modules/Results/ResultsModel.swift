import Foundation
import SFNetKit
import Combine

class ResultsModel {
    private let netKit: NetKit
    private var subscriber: AnyCancellable?
    
    @Published
    var noSearchResults: Bool = false
    
    @Published
    var requestResult: Result<[SearchItemResponse], NetworkError>?
    
    @Published
    var searching: Bool = false
    
    required init(netKit: NetKit) {
        self.netKit = netKit
    }
    
    deinit {
        subscriber?.cancel()
        subscriber = nil
    }
    
    func searchWord(with id: String) {
        guard !id.isEmpty else {
            return
        }
        searching = true
        subscriber = netKit.request(path: .wordId(id))
            .sink(receiveCompletion: { [weak self] completion in
                self?.searching = false
                if case .failure(let networkError) = completion {
                    self?.requestResult = .failure(networkError)
                    if case .noSearchResults = networkError {
                        self?.noSearchResults = true
                    }
                }
            }, receiveValue: { [weak self] searchResultsResponse in
                self?.requestResult = .success(searchResultsResponse)
            })
    }
    
    static var mock: Self {
        return .init(netKit: NetKit.default)
    }
}
