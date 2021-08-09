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
              number: Number,
              degree: AdjectiveDegree) -> [SearchItemFormResponse] {
        
        guard let declension = Declension(rawValue: tab.rawValue) else {
            debugPrint(self, #function, #line)
            return emptySearchItemFormsResponse
        }
        guard let forms = data?.forms, !forms.isEmpty else {
            debugPrint(self, #function, #line)
            return emptySearchItemFormsResponse
        }
        if degree == .comparative, declension == .strong {
            return emptySearchItemFormsResponse
        }
        let result: [SearchItemFormResponse] = {
            if degree == .comparative && declension == .weak {
                return filterWeakComparativeForms(forms, grammarCase: grammarCase, number: number)
            } else {
                return forms.filter {
                    $0.grammarCase == grammarCase
                        && $0.declension == declension
                        && $0.number == number
                        && $0.adjectiveDegree == degree
                }
                .sorted(by: { $0.gender.priority > $1.gender.priority })
            }
        }()
        return result
    }
    
    private func filterWeakComparativeForms(_ data: [SearchItemFormResponse],
                                            grammarCase: GrammarCase,
                                            number: Number) -> [SearchItemFormResponse] {
        return data.filter {
            $0.grammarCase == grammarCase
                && $0.number == number
                && $0.adjectiveDegree == .comparative
        }
        .sorted(by: { $0.gender.priority > $1.gender.priority })
    }
    
    private var emptySearchItemFormsResponse: [SearchItemFormResponse] {
        [
            emptySearchItemFormResponse(with: .masculine),
            emptySearchItemFormResponse(with: .feminine),
            emptySearchItemFormResponse(with: .neuter)
        ]
    }
    
    private func emptySearchItemFormResponse(with gender: Gender) -> SearchItemFormResponse {
        .init(inflectionalTag: gender.rawValue.uppercased(), word: .emptyFormString)
    }
    
    // MARK: - Mock / Preview
    
    static var mockWithoutData: Self = .init(data: nil)
    static var mockWithData: Self = .init(data: .fallegurMock)
}
