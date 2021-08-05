import Foundation

struct VerbImperativeTextManager {
    // MARK: - Type Aliases
    
    private typealias VerbLK = LocalizationKey.Grammar.Verb
    private typealias PronounLK = LocalizationKey.Grammar.Pronoun
    
    // MARK: - Strings
    
    var imperativeMood: String {
        VerbLK.ImperativeMood.translated.localizedString
    }
    
    var activeVoice: String {
        VerbLK.ActiveVoice.translated.localizedString
    }
    
    var middleVoice: String {
        VerbLK.MiddleVoice.translated.localizedString
    }
    
    var root: String {
        LocalizationKey.verbRoot.localizedString
    }
    
    func tip(for pronoun: Pronoun) -> String {
        let dash = "–"
        let space = " "
        switch pronoun {
        case .you(.singular):
            let left = PronounLK.You.Singular.native.localizedString
            let right = PronounLK.You.Singular.translated.localizedString
            let tip = LocalizationKey.pronounYouSingularTip.localizedString
            let result = left + space + dash + space + right
            if tip.isEmpty {
                return result
            } else {
                return result + space + tip
            }
        case .you(.plural):
            let left = PronounLK.You.Plural.native.localizedString
            let right = PronounLK.You.Plural.translated.localizedString
            let tip = LocalizationKey.pronounYouPluralTip.localizedString
            let result = left + space + dash + space + right
            if tip.isEmpty {
                return result
            } else {
                return result + space + tip
            }
        default:
            return .emptyFormString
        }
    }
    
    var noFormsTitle: String {
        LocalizationKey.NoForms.title.localizedString
    }
    
    var noFormsDescription: String {
        LocalizationKey.NoForms.description.localizedString
    }
    
    var close: String {
        LocalizationKey.close.localizedString
    }
    
    // MARK: - Mock / Preview
    
    static var mock: VerbImperativeTextManager = .init()
}
