import Foundation
import SFUIKit

final class NumeralModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    var noForms: Bool {
        data?.forms?.isEmpty ?? true
    }
    
    var numeralWord: String? {
        data?.word
    }
    
    func forms(at tab: NumeralViewTab, for grammarCase: GrammarCase) -> [SearchItemFormResponse] {
        guard let forms = data?.forms, !forms.isEmpty else {
            return []
        }
        let number = tab.number()
        let filteredForms = forms.filter {
            $0.number == number
                && $0.grammarCase == grammarCase
        }
        return filteredForms
    }
    
    // MARK: - Mock / Preview
    
    static var mock: NumeralModel {
        .init(data: .einnMock)
    }
}

// MARK: - Extension of NumeralViewTab

fileprivate extension NumeralViewTab {
    func number() -> Number {
        switch self {
        case .singular:
            return .singular
        case .plural:
            return .plural
        }
    }
}
