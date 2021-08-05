import Foundation

struct VerbPastParticipleModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    var noData: Bool {
        guard let forms = data?.forms, !forms.isEmpty else {
            return true
        }
        return forms
            .filter {
                $0.participle && $0.tense == .past
            }
            .isEmpty
    }
    
    func forms(at tab: VerbPastParticipleViewTab,
               grammarCase: GrammarCase,
               number: Number) -> [SearchItemFormResponse] {
        
        guard let declension = Declension(rawValue: tab.rawValue) else {
            debugPrint(self, #function, #line)
            return []
        }
        guard let forms = data?.forms, !forms.isEmpty else {
            debugPrint(self, #function, #line)
            return []
        }
        let result = forms
            .filter { $0.participle
                && $0.declension == declension
                && $0.grammarCase == grammarCase
                && $0.number == number
                && $0.tense == .past
            }
            .sorted(by: { $0.gender.priority > $1.gender.priority })
            .filter { $0.gender != .none }
        return result
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self {
        .init(data: nil)
    }
}
