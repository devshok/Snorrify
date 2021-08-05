import Foundation

struct VerbImperativeModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    func formWithRoot(verbVoice: VerbVoice) -> SearchItemFormResponse? {
        return data?.forms?
            .filter { $0.rootable && $0.verbVoice == verbVoice }
            .first
    }
    
    func imperativeForms(voice: VerbVoice) -> [SearchItemFormResponse] {
        guard let forms = data?.forms, !forms.isEmpty else {
            return []
        }
        return forms
            .filter {
                $0.mood == .imperative
                    && $0.verbVoice == voice
                    && !$0.rootable
            }
            .sorted(by: { $0.pronoun.priority > $1.pronoun.priority })
    }
    
    // MARK: - Mock / Preview
    
    static var mock: VerbImperativeModel {
        return .init(data: .skiljaWithImperativeFormsMock)
    }
}
