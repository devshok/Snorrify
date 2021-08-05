import Foundation

struct VerbTextManager {
    private typealias LK = LocalizationKey.Grammar.Verb
    static var mock: VerbTextManager { .init() }
    
    var empty: String {
        LocalizationKey.empty.localizedString
    }
    
    var presentParticiple: String {
        LK.Participle.Present.translated.localizedString
    }
    
    var close: String {
        LocalizationKey.close.localizedString
    }
}
