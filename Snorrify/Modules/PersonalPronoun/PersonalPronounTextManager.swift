import Foundation

struct PersonalPronounTextManager {
    // MARK: - Strings
    
    func tableTitle(for number: Number) -> String {
        switch number {
        case .singular:
            return LocalizationKey.Grammar.Number.singular.localizedString
        case .plural:
            return LocalizationKey.Grammar.Number.plural.localizedString
        case .none:
            return .emptyFormString
        }
    }
    
    func cellSubtitle(for grammarCase: GrammarCase) -> String {
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
    
    var noFormsTitle: String {
        LocalizationKey.NoForms.title.localizedString
    }
    
    var noFormsDescription: String {
        LocalizationKey.NoForms.description.localizedString
    }
    
    // MARK: - Mock / Preview
    
    static var mock: Self = .init()
}
