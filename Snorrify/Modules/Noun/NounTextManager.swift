import Foundation

struct NounTextManager {
    private typealias LK = LocalizationKey
    static var mock: Self = .init()
    
    var definiteArticle: String {
        LK.Results.Article.yes.localizedString
    }
    
    var indefiniteArticle: String {
        LK.Results.Article.no.localizedString
    }
    
    func tableSectionTitle(for number: Number) -> String {
        switch number {
        case .singular:
            return LK.Results.singularForms.localizedString
        case .plural:
            return LK.Results.pluralForms.localizedString
        case .none:
            return ""
        }
    }
    
    func cellSubtitle(for grammarCase: GrammarCase) -> String {
        switch grammarCase {
        case .nominative:
            return LK.Grammar.GrammarCase.nominative.localizedString
        case .accusative:
            return LK.Grammar.GrammarCase.accusative.localizedString
        case .dative:
            return LK.Grammar.GrammarCase.dative.localizedString
        case .genitive:
            return LK.Grammar.GrammarCase.genitive.localizedString
        case .none:
            return ""
        }
    }
}
