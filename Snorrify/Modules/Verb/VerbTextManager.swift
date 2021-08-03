import Foundation

struct VerbTextManager {
    private typealias LK = LocalizationKey.Grammar.Verb
    static var mock: VerbTextManager { .init() }
    
    var infinitive: String {
        LocalizationKey.infinitive.localizedString
    }
    
    var infinitivePrefix: String {
        LK.infinitivePrefix.localizedString
    }
    
    var empty: String {
        LocalizationKey.empty.localizedString
    }
    
    func title(for category: VerbViewCategory) -> String {
        switch category {
        case .voice(let voice):
            return title(for: voice)
        case .imperativeMood:
            return imperativeMood
        case .supine:
            return supine
        case .participle(let participle):
            return title(for: participle)
        }
    }
    
    private func title(for voice: VerbViewCategory.Voice) -> String {
        switch voice {
        case .active:
            return activeVoice
        case .middle:
            return middleVoice
        }
    }
    
    private func title(for participle: VerbViewCategory.Participle) -> String {
        switch participle {
        case .present:
            return presentParticiple
        case .past:
            return pastParticiple
        }
    }
    
    private var activeVoice: String {
        LK.ActiveVoice.native.localizedString
    }
    
    private var middleVoice: String {
        LK.MiddleVoice.native.localizedString
    }
    
    private var imperativeMood: String {
        LK.ImperativeMood.native.localizedString
    }
    
    private var supine: String {
        LK.Supine.native.localizedString
    }
    
    private var presentParticiple: String {
        LK.Participle.Present.native.localizedString
    }
    
    private var pastParticiple: String {
        LK.Participle.Past.native.localizedString
    }
}
