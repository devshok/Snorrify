import Foundation
import SFNetKit
import Combine

class SearchModel {
    typealias JSON = [String: Any]
    
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
        searching = true
        subscriber = netKit.request(path: .word(word)).sink(receiveCompletion: { completion in
            self.searching = false
            if case .failure(let networkError) = completion {
                self.lastRequestResult = .failure(networkError)
                if case .noSearchResults = networkError {
                    self.noSearchResults = true
                }
            }
        }, receiveValue: { searchResultsResponse in
            self.lastRequestResult = .success(searchResultsResponse)
        })
    }
    
    static var mock: Self {
        return .init(netKit: NetKit.default)
    }
}
