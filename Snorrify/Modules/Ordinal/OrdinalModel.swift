import Foundation

final class OrdinalModel {
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
    
    func forms(grammarCase: GrammarCase,
               number: Number) -> [SearchItemFormResponse] {
        
        guard let forms = data?.forms, !forms.isEmpty else {
            return emptyForms
        }
        let result: [SearchItemFormResponse] = {
            return forms.filter {
                $0.grammarCase == grammarCase && $0.number == number
            }
            .sorted(by: { $0.gender.priority > $1.gender.priority })
        }()
        return result
    }
    
    private var emptyForms: [SearchItemFormResponse] {
        [
            emptySearchItemFormResponse(with: .masculine),
            emptySearchItemFormResponse(with: .feminine),
            emptySearchItemFormResponse(with: .neuter)
        ]
    }
    
    private func emptySearchItemFormResponse(
        with gender: Gender
    ) -> SearchItemFormResponse {
        .init(inflectionalTag: gender.rawValue.uppercased(), word: .emptyFormString)
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> OrdinalModel {
        let data: SearchItemResponse? = withData ? .annarMock : nil
        return .init(data: data)
    }
}
