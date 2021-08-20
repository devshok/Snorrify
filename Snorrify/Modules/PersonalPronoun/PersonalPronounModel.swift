import Foundation

final class PersonalPronounModel {
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
    
    func forms(grammarCase: GrammarCase, number: Number) -> [SearchItemFormResponse] {
        guard let forms = data?.forms,
              !forms.isEmpty,
              grammarCase != .none,
              number != .none
        else {
            debugPrint(self, #function, #line)
            return []
        }
        return forms
            .filter {
                $0.grammarCase == grammarCase
                    && $0.number == number
            }
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> PersonalPronounModel {
        switch withData {
        case true:
            return .init(data: .hannMock)
        case false:
            return .init(data: nil)
        }
    }
}
