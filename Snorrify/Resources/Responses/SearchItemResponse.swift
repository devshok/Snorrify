import Foundation
import SFUIKit

struct SearchItemResponse: Codable, Hashable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id = "guid" // String
        case word = "ord" // String
        case wordClass = "ofl" // WordClass
        case gender = "kyn" // Gender
        case forms = "bmyndir" // [InflectionalForm]?
    }
    
    let id: String
    let word: String
    let wordClass: WordClass
    let gender: Gender
    let forms: [SearchItemFormResponse]?
    
    init(id: String,
         word: String,
         wordClass: WordClass,
         gender: Gender,
         forms: [SearchItemFormResponse]? = nil
    ) {
        self.id = id
        self.word = word
        self.wordClass = wordClass
        self.gender = gender
        self.forms = forms
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.word = try container.decode(String.self, forKey: .word)
        self.wordClass = try container.decode(WordClass.self, forKey: .wordClass)
        self.gender = try container.decode(Gender.self, forKey: .gender)
        self.forms = try? container.decodeIfPresent([SearchItemFormResponse].self, forKey: .forms)
    }
    
    static var mockA: SearchItemResponse {
        return .init(id: "bcc5e46bdc42078aa136eb2bdb78fbe0",
                     word: "skilja",
                     wordClass: .verb,
                     gender: .none,
                     forms: [])
    }
    
    static var mockB: SearchItemResponse {
        return .init(id: "40cc53ce261fd6640574a4c828ca6db7",
                     word: "skilja",
                     wordClass: .noun,
                     gender: .feminine,
                     forms: [])
    }
    
    static var bananiMock: SearchItemResponse {
        let forms: [SearchItemFormResponse] =
            SearchItemFormResponse.bananiMockSingularForms +
            SearchItemFormResponse.bananiMockPluralForms
        return .init(id: "806e3de7c6f6a6abc210db601cd73917",
                     word: "banani",
                     wordClass: .noun,
                     gender: .masculine,
                     forms: forms)
    }
}

extension SearchItemResponse {
    func toCellOptionViewContract(
        onTap action: @escaping (_ id: String) -> Void
    ) -> SFCellOptionViewContract {
        let subtitle = wordClass.localizedString(gender: gender)
        return .init(id: id, title: word, subtitle: subtitle, action: action)
    }
}

fileprivate extension WordClass {
    private typealias Key = LocalizationKey.Results.Option
    
    func localizedString(gender: Gender = .none) -> String {
        switch self {
        case .noun:
            return nounLocalizedString(gender: gender)
        case .verb:
            return Key.verb.localizedString
        case .adjective:
            return Key.adjective.localizedString
        case .reflexiveNoun:
            return Key.reflexivePronoun.localizedString
        case .adverb:
            return Key.adverb.localizedString
        case .otherPronoun:
            return Key.otherPronoun.localizedString
        case .preposition:
            return Key.preposition.localizedString
        case .definiteArticle:
            return Key.definiteArticle.localizedString
        case .nominativeMarker:
            return Key.nominativeMarker.localizedString
        case .personalPronoun:
            return Key.personalPronoun.localizedString
        case .ordinal:
            return Key.ordinal.localizedString
        case .conjunction:
            return Key.conjunction.localizedString
        case .numeral:
            return Key.numeral.localizedString
        case .exclamation:
            return Key.exclamation.localizedString
        case .none:
            return ""
        }
    }
    
    private func nounLocalizedString(gender: Gender) -> String {
        switch gender {
        case .masculine:
            return Key.Noun.masculine.localizedString
        case .feminine:
            return Key.Noun.feminine.localizedString
        case .neuter:
            return Key.Noun.neuter.localizedString
        case .none:
            return ""
        }
    }
}
