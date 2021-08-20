import Foundation
import SFUIKit

final class AdverbModel {
    // MARK: - Properties
    
    private var data: SearchItemResponse?
    
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
    
    func forms(for degree: AdjectiveDegree) -> [SearchItemFormResponse] {
        switch degree {
        case .positive, .comparative, .superlative:
            guard let forms = data?.forms, !forms.isEmpty else {
                return []
            }
            return forms.filter { $0.adjectiveDegree == degree }
        case .none:
            return []
        }
    }
    
    // MARK: - Preview / Mock
    
    static func mock(withData: Bool) -> AdverbModel {
        switch withData {
        case true:
            return .init(data: .leiðinlegaMock)
        case false:
            return .init(data: nil)
        }
    }
}
