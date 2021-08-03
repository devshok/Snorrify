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
        return LocalizationKey.for(word: word).localizedString
    }
    
    var noResultsPlaceholderDefaultDescription: String {
        return LocalizationKey.Search.Placeholder.tryAnotherSearch.localizedString
    }
    
    var chooseCategory: String {
        return LocalizationKey.chooseCategory.localizedString
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
}

// MARK: - Verb

extension ResultsTextManager {
    private typealias LK = LocalizationKey.Grammar.Verb
    
    private var activeVoice: String {
        LK.ActiveVoice.native.localizedString
    }
    
    private var activeVoiceTranslated: String {
        LK.ActiveVoice.translated.localizedString
    }
    
    private var middleVoice: String {
        LK.MiddleVoice.native.localizedString
    }
    
    private var middleVoiceTranslated: String {
        LK.MiddleVoice.translated.localizedString
    }
    
    private var imperativeMood: String {
        LK.ImperativeMood.native.localizedString
    }
    
    private var imperativeMoodTranslated: String {
        LK.ImperativeMood.translated.localizedString
    }
    
    private var supine: String {
        LK.Supine.native.localizedString
    }
    
    private var supineTranslated: String {
        LK.Supine.translated.localizedString
    }
    
    private var presentParticiple: String {
        LK.Participle.Present.native.localizedString
    }
    
    private var presentParticipleTranslated: String {
        LK.Participle.Present.translated.localizedString
    }
    
    private var pastParticiple: String {
        LK.Participle.Past.native.localizedString
    }
    
    private var pastParticipleTranslated: String {
        LK.Participle.Past.translated.localizedString
    }
}
