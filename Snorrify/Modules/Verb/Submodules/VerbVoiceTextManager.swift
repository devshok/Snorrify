import Foundation

struct VerbVoiceTextManager {
    // MARK: - Type Aliases
    
    private typealias VerbKey = LocalizationKey.Grammar.Verb
    
    // MARK: - Strings
    
    var infinitive: String {
        LocalizationKey.infinitive.localizedString
    }
    
    var infinitivePrefix: String {
        VerbKey.infinitivePrefix.localizedString
    }
    
    func title(context: VerbVoiceContext) -> String {
        switch context {
        case .active:
            return VerbKey.ActiveVoice.translated.localizedString
        case .middle:
            return VerbKey.MiddleVoice.translated.localizedString
        case .none:
            return .emptyFormString
        }
    }
    
    var close: String {
        LocalizationKey.close.localizedString
    }
    
    var moods: String {
        LocalizationKey.moods.localizedString
    }
    
    var indicative: String {
        VerbKey.Mood.indicative.localizedString
    }
    
    var subjunctive: String {
        VerbKey.Mood.subjunctive.localizedString
    }
    
    var presentTense: String {
        VerbKey.Tense.present.localizedString
    }
    
    var pastTense: String {
        VerbKey.Tense.past.localizedString
    }
    
    func formSubtitle(for pronoun: Pronoun) -> String {
        typealias PronounKey = LocalizationKey.Grammar.Pronoun
        let dash = "–"
        let space = " "
        switch pronoun {
        case .me:
            let native = PronounKey.Me.native.localizedString
            let translated = PronounKey.Me.translated.localizedString
            return native + space + dash + space + translated
        case .you(.singular):
            let native = PronounKey.You.Singular.native.localizedString
            let translated = PronounKey.You.Singular.translated.localizedString
            let tip = LocalizationKey.pronounYouSingularTip.localizedString
            let result = native + space + dash + space + translated
            if tip.isEmpty {
                return result
            } else {
                return result + space + tip
            }
        case .he, .she, .it:
            let heNative = PronounKey.He.native.localizedString
            let heTranslated = PronounKey.He.translated.localizedString
            let sheNative = PronounKey.She.native.localizedString
            let sheTranslated = PronounKey.She.translated.localizedString
            let itNative = PronounKey.That.native.localizedString
            let itTranslated = PronounKey.That.translated.localizedString
            let nativePronouns = [heNative, sheNative, itNative]
            let translatedPronouns = [heTranslated, sheTranslated, itTranslated]
            let left = nativePronouns.joined(separator: "/")
            let right = translatedPronouns.joined(separator: "/")
            return left + space + dash + space + right
        case .we:
            let native = PronounKey.We.native.localizedString
            let translated = PronounKey.We.translated.localizedString
            return native + space + dash + space + translated
        case .you(.plural):
            let native = PronounKey.You.Plural.native.localizedString
            let translated = PronounKey.You.Plural.translated.localizedString
            let tip = LocalizationKey.pronounYouPluralTip.localizedString
            let result = native + space + dash + space + translated
            if tip.isEmpty {
                return result
            } else {
                return result + space + tip
            }
        case .they:
            let theyMasculineNative = PronounKey.They.Masculine.native.localizedString
            let theyFeminineNative = PronounKey.They.Feminine.native.localizedString
            let theyNeuterNative = PronounKey.They.Neuter.native.localizedString
            let nativePronouns = [theyMasculineNative, theyFeminineNative, theyNeuterNative]
            let left = nativePronouns.joined(separator: "/")
            let right = PronounKey.They.Masculine.translated.localizedString
            let masculine = LocalizationKey.Grammar.Gender.masculine.localizedString
            let feminine = LocalizationKey.Grammar.Gender.feminine.localizedString
            let neuter = LocalizationKey.Grammar.Gender.neuter.localizedString
            let genders = LocalizationKey.genders.localizedString
            let tip = "(\(masculine), \(feminine) and \(neuter) \(genders))"
            return left + space + dash + space + right + space + tip
        case .you(.none), .none:
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
    
    static var mock: VerbVoiceTextManager {
        .init()
    }
}
