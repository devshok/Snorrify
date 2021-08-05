import Foundation

struct VerbVoiceModel {
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    func infinitiveForm(context: VerbVoiceContext) -> String {
        guard let forms = data?.forms,
              !forms.isEmpty,
              let verbVoice = VerbVoice(rawValue: context.rawValue) else
        {
            debugPrint(self, #function, #line)
            return .emptyFormString
        }
        return forms
            .filter { $0.verbVoice == verbVoice && $0.infinitive }
            .first?
            .word ?? .emptyFormString
    }
    
    func forms(context: VerbVoiceContext, tense: Tense, mood: VerbMood) -> [SearchItemFormResponse] {
        guard let forms = data?.forms,
              !forms.isEmpty,
              let verbVoice = VerbVoice(rawValue: context.rawValue) else
        {
            debugPrint(self, #function, #line)
            return []
        }
        let result = forms.filter {
            $0.tense == tense
                && $0.verbVoice == verbVoice
                && $0.mood == mood
                && !$0.impersonal
                && !$0.questionable
        }
        return result
    }
    
    // MARK: - Mock / Preview
    
    static var mock: VerbVoiceModel {
        .init(data: .skiljaMock)
    }
}
