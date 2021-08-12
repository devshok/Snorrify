import Foundation

struct ResultsTextManager {
    // MARK: - Aliases
    
    private typealias DegreeLK = LocalizationKey.Adjective.Degree
    private typealias VerbLK = LocalizationKey.Grammar.Verb
    private typealias OptionLK = LocalizationKey.Results.Option
    
    // MARK: - Mock Previews
    
    static var mock: Self = .init()
}

// MARK: - General

extension ResultsTextManager {
    var whichOne: String {
        LocalizationKey.whichOne.localizedString
    }
    
    var loading: String {
        LocalizationKey.loading.localizedString
    }
    
    var close: String {
        LocalizationKey.close.localizedString
    }
    
    var noResults: String {
        LocalizationKey.noResults.localizedString
    }
    
    var empty: String {
        LocalizationKey.empty.localizedString
    }
    
    var chooseCategory: String {
        LocalizationKey.chooseCategory.localizedString
    }
}

// MARK: - Noun

extension ResultsTextManager {
    var indefiniteArticle: String {
        LocalizationKey.Results.Article.no.localizedString
    }
    
    var definiteArticle: String {
        LocalizationKey.Results.Article.yes.localizedString
    }
    
    var singularForms: String {
        LocalizationKey.singularForms.localizedString
    }
    
    var pluralForms: String {
        LocalizationKey.pluralForms.localizedString
    }
    
    func nounSubtitle(for `case`: GrammarCase) -> String {
        switch `case` {
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
}

// MARK: - Adjective

extension ResultsTextManager {
    func degree(_ degree: AdjectiveDegree, translated: Bool) -> String {
        switch degree {
        case .positive:
            return positiveDegree(translated: translated)
        case .comparative:
            return comparativeDegree(translated: translated)
        case .superlative:
            return superlativeDegree(translated: translated)
        case .none:
            return .emptyFormString
        }
    }
    
    private func positiveDegree(translated: Bool) -> String {
        switch translated {
        case true:
            return DegreeLK.Positive.translated.localizedString
        case false:
            return DegreeLK.Positive.native.localizedString
        }
    }
    
    private func comparativeDegree(translated: Bool) -> String {
        switch translated {
        case true:
            return DegreeLK.Comparative.translated.localizedString
        case false:
            return DegreeLK.Comparative.native.localizedString
        }
    }
    
    private func superlativeDegree(translated: Bool) -> String {
        switch translated {
        case true:
            return DegreeLK.Superlative.translated.localizedString
        case false:
            return DegreeLK.Superlative.native.localizedString
        }
    }
}

// MARK: - Verb

extension ResultsTextManager {
    func verbVoice(_ voice: VerbVoice, translated: Bool) -> String {
        switch voice {
        case .active:
            return activeVoice(translated: translated)
        case .middle:
            return middleVoice(translated: translated)
        case .none:
            return .emptyFormString
        }
    }
    
    private func activeVoice(translated: Bool) -> String {
        switch translated {
        case true:
            return VerbLK.ActiveVoice.translated.localizedString
        case false:
            return VerbLK.ActiveVoice.native.localizedString
        }
    }
    
    private func middleVoice(translated: Bool) -> String {
        switch translated {
        case true:
            return VerbLK.MiddleVoice.translated.localizedString
        case false:
            return VerbLK.MiddleVoice.native.localizedString
        }
    }
    
    func imperativeMood(translated: Bool) -> String {
        switch translated {
        case true:
            return VerbLK.ImperativeMood.translated.localizedString
        case false:
            return VerbLK.ImperativeMood.native.localizedString
        }
    }
    
    func supine(translated: Bool) -> String {
        switch translated {
        case true:
            return VerbLK.Supine.translated.localizedString
        case false:
            return VerbLK.Supine.native.localizedString
        }
    }
    
    func participle(tense: Tense, translated: Bool) -> String {
        switch tense {
        case .present:
            return presentParticiple(translated: translated)
        case .past:
            return pastParticiple(translated: translated)
        case .none:
            return .emptyFormString
        }
    }
    
    private func pastParticiple(translated: Bool) -> String {
        switch translated {
        case true:
            return VerbLK.Participle.Past.translated.localizedString
        case false:
            return VerbLK.Participle.Past.native.localizedString
        }
    }
    
    private func presentParticiple(translated: Bool) -> String {
        switch translated {
        case true:
            return VerbLK.Participle.Present.translated.localizedString
        case false:
            return VerbLK.Participle.Present.native.localizedString
        }
    }
}

// MARK: - Error

extension ResultsTextManager {
    var error: String {
        LocalizationKey.error.localizedString
    }
    
    var errorUnknownReasonDescription: String {
        LocalizationKey.NetworkError.unknown.localizedString
    }
}

// MARK: - Word Class

extension ResultsTextManager {
    func optionSubtitle(for wordClass: WordClass, gender: Gender) -> String {
        switch wordClass {
        case .noun:
            return optionNounSubtitle(gender: gender)
        case .verb:
            return OptionLK.verb.localizedString
        case .adjective:
            return OptionLK.adjective.localizedString
        case .reflexiveNoun:
            return OptionLK.reflexivePronoun.localizedString
        case .adverb:
            return OptionLK.adverb.localizedString
        case .otherPronoun:
            return OptionLK.otherPronoun.localizedString
        case .preposition:
            return OptionLK.preposition.localizedString
        case .definiteArticle:
            return OptionLK.definiteArticle.localizedString
        case .nominativeMarker:
            return OptionLK.nominativeMarker.localizedString
        case .personalPronoun:
            return OptionLK.personalPronoun.localizedString
        case .ordinal:
            return OptionLK.ordinal.localizedString
        case .conjunction:
            return OptionLK.conjunction.localizedString
        case .numeral:
            return OptionLK.numeral.localizedString
        case .exclamation:
            return OptionLK.exclamation.localizedString
        case .none:
            return ""
        }
    }
    
    private func optionNounSubtitle(gender: Gender) -> String {
        switch gender {
        case .masculine:
            return OptionLK.Noun.masculine.localizedString
        case .feminine:
            return OptionLK.Noun.feminine.localizedString
        case .neuter:
            return OptionLK.Noun.neuter.localizedString
        case .none:
            return ""
        }
    }
}
