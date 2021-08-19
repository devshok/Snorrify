import Combine
import SFNetKit

final class ResultsModel: ObservableObject {
    // MARK: - Properties
    
    private let netKit: NetKit
    private let dbKit: DBKit
    private let sourceData: [SearchItemResponse]
    
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Publishers
    
    @Published
    var dataPublisher: [SearchItemResponse] = []
    
    @Published
    var loadingPublisher: Bool = false
    
    @Published
    var errorPublisher: NetworkError = .none
    
    private var requestPublisher: AnyPublisher<[SearchItemResponse], NetworkError>?
    
    // MARK: - Subscribers
    
    private var requestSubscriber: AnyCancellable?
    
    // MARK: - Life Cycle
    
    init(netKit: NetKit, dbKit: DBKit, data: [SearchItemResponse]) {
        self.netKit = netKit
        self.dbKit = dbKit
        self.sourceData = data
        self.dataPublisher = data
    }
    
    deinit {
        stopListenLastRequest()
        debugPrint(self, #function, #line)
    }
    
    // MARK: - View Model Actions
    
    var word: String? {
        sourceData.first?.word
    }
    
    func loadForms(for id: String) {
        let item = sourceData
            .filter { $0.id == id }
            .first
        guard let wordId = item?.id else {
            errorPublisher = .badRequest
            debugPrint(self, #function, #line, "no word id")
            return
        }
        guard !loadingPublisher else {
            debugPrint(self, #function, #line, "still loading previous request")
            return
        }
        stopListenLastRequest()
        loadingPublisher = true
        requestPublisher = netKit.request(path: .wordId(wordId))
        startListenNewRequest()
    }
    
    func isFave(item: SearchItemResponse?) -> Bool {
        return dbKit.contains(favorite: item)
    }
    
    func fave(item: SearchItemResponse?) {
        let favorite = DBFaveItemResponse(item: item)
        dbKit.add(favorite: favorite)
    }
    
    func unfave(item: SearchItemResponse?) {
        let favorite = DBFaveItemResponse(item: item)
        dbKit.remove(favorite: favorite)
    }
    
    func addToHistory(item: SearchItemResponse?) {
        let searchResult = DBSearchItemResponse(item: item)
        dbKit.add(searchResult: searchResult)
    }
    
    // MARK: - Events
    
    private func startListenNewRequest() {
        guard let publisher = requestPublisher else {
            return
        }
        requestSubscriber = publisher
            .sink(receiveCompletion: { [weak self] completion in
                self?.handleRequestCompletion(completion)
            }, receiveValue: { [weak self] value in
                self?.dataPublisher = value
            })
    }
    
    func stopListenLastRequest() {
        requestSubscriber?.cancel()
        requestSubscriber = nil
    }
    
    // MARK: - NetKit Completions
    
    private func handleRequestCompletion(_ completion: Subscribers.Completion<NetworkError>) {
        defer {
            loadingPublisher = false
        }
        switch completion {
        case .finished:
            errorPublisher = .none
        case .failure(let newError):
            errorPublisher = .other(localizedDescription: newError.localized)
        }
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> ResultsModel {
        let data: [SearchItemResponse]
            = withData ? SearchItemResponse.skiljaOptionsMock : []
        return .init(netKit: .default, dbKit: .shared, data: data)
    }
}
