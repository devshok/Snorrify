import Foundation

struct AdjectiveTextManager {
    // MARK: - Type Aliases
    
    private typealias AdjectiveLK = LocalizationKey.Adjective
    
    // MARK: - Strings
    
    func title(for category: AdjectiveCategory) -> String {
        switch category {
        case .positiveDegree:
            return AdjectiveLK.Degree.Positive.translated.localizedString
        case .comparativeDegree:
            return AdjectiveLK.Degree.Comparative.translated.localizedString
        case .superlativeDegree:
            return AdjectiveLK.Degree.Superlative.translated.localizedString
        case .none:
            return .emptyFormString
        }
    }
    
    var declensions: String {
        LocalizationKey.declensions.localizedString
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
    
    func title(for tab: AdjectiveViewTab) -> String {
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
            return LocalizationKey.Grammar.Number.singular.localizedString
        case .plural:
            return LocalizationKey.Grammar.Number.plural.localizedString
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
