import Foundation

struct ResultsTextManager {
    static var mock: Self = .init()
    
    var whichOne: String {
        LocalizationKey.whichOne.localizedString
    }
    
    var empty: String {
        LocalizationKey.empty.localizedString
    }
    
    var close: String {
        LocalizationKey.close.localizedString
    }
    
    var error: String {
        LocalizationKey.error.localizedString
    }
    
    var loading: String {
        LocalizationKey.loading.localizedString
    }
    
    var noResultsPlaceholderTitle: String {
        LocalizationKey.noResults.localizedString
    }
    
    func noResultsPlaceholderDescription(for word: String) -> String {
        LocalizationKey.for(word: word).localizedString
    }
    
    var noResultsPlaceholderDefaultDescription: String {
        LocalizationKey.Search.Placeholder.tryAnotherSearch.localizedString
    }
    
    var chooseCategory: String {
        LocalizationKey.chooseCategory.localizedString
    }
    
    var unknownErrorDescription: String {
        LocalizationKey.NetworkError.unknown.localizedString
    }
    
    func title(for category: VerbViewCategory,
               translated: Bool = false) -> String {
        switch category {
        case .voice(let voice):
            return title(for: voice, translated: translated)
        case .imperativeMood:
            return translated ? imperativeMoodTranslated : imperativeMood
        case .supine:
            return translated ? supineTranslated : supine
        case .participle(let participle):
            return title(for: participle, translated: translated)
        case .none:
            return ""
        }
    }
    
    private func title(for voice: VerbViewCategory.Voice,
                       translated: Bool) -> String {
        switch voice {
        case .active:
            return translated ? activeVoiceTranslated : activeVoice
        case .middle:
            return translated ? middleVoiceTranslated : middleVoice
        }
    }
    
    private func title(for participle: VerbViewCategory.Participle,
                       translated: Bool) -> String {
        switch participle {
        case .present:
            return translated ? presentParticipleTranslated : presentParticiple
        case .past:
            return translated ? pastParticipleTranslated : pastParticiple
        }
    }
    
    func title(for category: AdjectiveCategory, translated: Bool = false) -> String {
        switch category {
        case .positiveDegree:
            return translated ? positiveDegreeTranslated : positiveDegree
        case .comparativeDegree:
            return translated ? comparativeDegreeTranslated : comparativeDegree
        case .superlativeDegree:
            return translated ? superlativeDegreeTranslated : superlativeDegree
        case .none:
            return .emptyFormString
        }
    }
}

// MARK: - Verb

extension ResultsTextManager {
    private typealias VerbLK = LocalizationKey.Grammar.Verb
    
    private var activeVoice: String {
        VerbLK.ActiveVoice.native.localizedString
    }
    
    private var activeVoiceTranslated: String {
        VerbLK.ActiveVoice.translated.localizedString
    }
    
    private var middleVoice: String {
        VerbLK.MiddleVoice.native.localizedString
    }
    
    private var middleVoiceTranslated: String {
        VerbLK.MiddleVoice.translated.localizedString
    }
    
    private var imperativeMood: String {
        VerbLK.ImperativeMood.native.localizedString
    }
    
    private var imperativeMoodTranslated: String {
        VerbLK.ImperativeMood.translated.localizedString
    }
    
    private var supine: String {
        VerbLK.Supine.native.localizedString
    }
    
    private var supineTranslated: String {
        VerbLK.Supine.translated.localizedString
    }
    
    private var presentParticiple: String {
        VerbLK.Participle.Present.native.localizedString
    }
    
    private var presentParticipleTranslated: String {
        VerbLK.Participle.Present.translated.localizedString
    }
    
    private var pastParticiple: String {
        VerbLK.Participle.Past.native.localizedString
    }
    
    private var pastParticipleTranslated: String {
        VerbLK.Participle.Past.translated.localizedString
    }
}

// MARK: - Adjective

extension ResultsTextManager {
    private typealias AdjectiveLK = LocalizationKey.Adjective
    
    private var positiveDegree: String {
        AdjectiveLK.Degree.Positive.native.localizedString
    }
    
    private var positiveDegreeTranslated: String {
        AdjectiveLK.Degree.Positive.translated.localizedString
    }
    
    private var comparativeDegree: String {
        AdjectiveLK.Degree.Comparative.native.localizedString
    }
    
    private var comparativeDegreeTranslated: String {
        AdjectiveLK.Degree.Comparative.translated.localizedString
    }
    
    private var superlativeDegree: String {
        AdjectiveLK.Degree.Superlative.native.localizedString
    }
    
    private var superlativeDegreeTranslated: String {
        AdjectiveLK.Degree.Superlative.translated.localizedString
    }
}
