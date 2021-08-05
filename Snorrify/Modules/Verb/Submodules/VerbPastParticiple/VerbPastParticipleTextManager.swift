import Foundation

struct VerbPastParticipleTextManager {
    // MARK: - Strings
    
    var title: String {
        LocalizationKey.Grammar.Verb.Participle.Past.translated.localizedString
    }
    
    var close: String {
        LocalizationKey.close.localizedString
    }
    
    var noFormsTitle: String {
        LocalizationKey.NoForms.title.localizedString
    }
    
    var noFormsDescription: String {
        LocalizationKey.NoForms.description.localizedString
    }
    
    var declensions: String {
        LocalizationKey.declensions.localizedString
    }
    
    func title(for tab: VerbPastParticipleViewTab) -> String {
        switch tab {
        case .strong:
            return LocalizationKey.Grammar.Declension.strong.localizedString
        case .weak:
            return LocalizationKey.Grammar.Declension.weak.localizedString
        }
    }
    
    func tableTitle(for grammarCase: GrammarCase) -> String {
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
    
    func tableSubtitle(for number: Number) -> String {
        switch number {
        case .singular:
            return LocalizationKey.singularForms.localizedString
        case .plural:
            return LocalizationKey.pluralForms.localizedString
        case .none:
            return .emptyFormString
        }
    }
    
    func tableCellSubtitle(for gender: Gender) -> String {
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
    
    // MARK: - Mock / Preview
    
    static var mock: Self = .init()
}
