import Foundation

final class VerbModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    var noData: Bool {
        return data?.forms?.isEmpty ?? true
    }
    
    func infinitiveForm(for tense: Tense) -> SearchItemFormResponse? {
        switch tense {
        case .present, .past:
            return data?.forms?
                .filter { $0.tense == tense && $0.infinitive }
                .first
        case .none:
            return nil
        }
    }
    
    // MARK: - Preview / Mock
    
    static var mock: VerbModel {
        .init(data: .skiljaMock)
    }
}
