import Foundation

final class ReflexivePronounModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    var word: String? {
        data?.word
    }
    
    var noData: Bool {
        data?.forms?.isEmpty ?? true
    }
    
    func forms(for grammarCase: GrammarCase) -> [SearchItemFormResponse] {
        guard let forms = data?.forms,
              !forms.isEmpty,
              grammarCase != .none
        else {
            return []
        }
        return forms.filter { $0.grammarCase == grammarCase }
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> ReflexivePronounModel {
        let data: SearchItemResponse? = withData ? .sigMock : nil
        return .init(data: data)
    }
}
