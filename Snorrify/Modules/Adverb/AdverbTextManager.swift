struct AdverbTextManager {
    // MARK: - Aliases
    
    private typealias LK = LocalizationKey.Adjective.Degree
    
    // MARK: - Strings
    
    func cellSubtitle(for degree: AdjectiveDegree) -> String {
        switch degree {
        case .positive:
            return LK.Positive.translated.localizedString
        case .comparative:
            return LK.Comparative.translated.localizedString
        case .superlative:
            return LK.Superlative.translated.localizedString
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
    
    // MARK: - Mock / Preview
    
    static var mock: Self = .init()
}
