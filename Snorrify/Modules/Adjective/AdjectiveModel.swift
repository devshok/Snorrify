import Foundation

struct AdjectiveModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    func noData(at tab: AdjectiveViewTab) -> Bool {
        guard let declension = Declension(rawValue: tab.rawValue) else {
            debugPrint(self, #function, #line)
            return true
        }
        guard let forms = data?.forms, !forms.isEmpty else {
            debugPrint(self, #function, #line)
            return true
        }
        return forms.filter { $0.declension == declension }.isEmpty
    }
    
    func data(at tab: AdjectiveViewTab,
              grammarCase: GrammarCase,
              number: Number) -> [SearchItemFormResponse] {
        
        guard let declension = Declension(rawValue: tab.rawValue) else {
            debugPrint(self, #function, #line)
            return emptySearchItemFormsResponse
        }
        guard let forms = data?.forms, !forms.isEmpty else {
            debugPrint(self, #function, #line)
            return emptySearchItemFormsResponse
        }
        return forms
            .filter {
                $0.declension == declension
                    && $0.grammarCase == grammarCase
                    && $0.number == number
            }
            .sorted(by: { $0.gender.priority > $1.gender.priority })
    }
    
    private var emptySearchItemFormsResponse: [SearchItemFormResponse] {
        [
            emptySearchItemFormResponse,
            emptySearchItemFormResponse,
            emptySearchItemFormResponse
        ]
    }
    
    private var emptySearchItemFormResponse: SearchItemFormResponse {
        .init(inflectionalTag: "", word: .emptyFormString)
    }
    
    // MARK: - Mock / Preview
    
    static var mockWithoutData: Self = .init(data: nil)
    static var mockWithData: Self = .init(data: .fallegurMock)
}
