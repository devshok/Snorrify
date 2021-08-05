import Foundation

struct VerbSupineTextManager {
    // MARK: - Type Aliases
    
    private typealias VerbLK = LocalizationKey.Grammar.Verb
    
    // MARK: - Strings
    
    var title: String {
        VerbLK.Supine.translated.localizedString
    }
    
    func subtitle(for verbVoice: VerbVoice) -> String {
        switch verbVoice {
        case .active:
            return VerbLK.ActiveVoice.translated.localizedString
        case .middle:
            return VerbLK.MiddleVoice.translated.localizedString
        case .none:
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
    
    static var mock: Self = .init()
}
