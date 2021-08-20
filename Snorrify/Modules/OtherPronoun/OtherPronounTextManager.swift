import Foundation

struct OtherPronounTextManager {
    // MARK: - Strings
    
    var subtitle: String {
        LocalizationKey.Adjective.Degree.Positive.translated.localizedString
    }
    
    func grammarCase(_ grammarCase: GrammarCase) -> String {
        switch grammarCase {
        case .nominative:
            return LocalizationKey.Grammar.GrammarCase.nominative.localizedString
        case .accusative:
            return LocalizationKey.Grammar.GrammarCase.accusative.localizedString
        case .dative:
            return LocalizationKey.Grammar.GrammarCase.dative.localizedString
        case .genitive:
            return LocalizationKey.Grammar.GrammarCase.genitive.localizedString
        case .none:
            return .emptyFormString
        }
    }
    
    func gender(_ gender: Gender) -> String {
        switch gender {
        case .masculine:
            return LocalizationKey.Grammar.Gender.masculine.localizedString
        case .feminine:
            return LocalizationKey.Grammar.Gender.feminine.localizedString
        case .neuter:
            return LocalizationKey.Grammar.Gender.neuter.localizedString
        case .none:
            return .emptyFormString
        }
    }
    
    func number(_ number: Number) -> String {
        switch number {
        case .singular:
            return LocalizationKey.Grammar.Number.singular.localizedString
        case .plural:
            return LocalizationKey.Grammar.Number.plural.localizedString
        case .none:
            return .emptyFormString
        }
    }
    
    var noFormsTitle: String {
        LocalizationKey.NoForms.title.localizedString
    }
    
    var noFormsDescription: String {
        LocalizationKey.NoForms.description.localizedString
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self = .init()
}

