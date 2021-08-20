import Foundation
import SFUIKit

struct SearchItemResponse: Codable, Hashable, Identifiable {
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id = "guid" // String
        case word = "ord" // String
        case wordClass = "ofl" // WordClass
        case gender = "kyn" // Gender
        case forms = "bmyndir" // [InflectionalForm]?
    }
    
    // MARK: - Properties
    
    let id: String
    let word: String
    let wordClass: WordClass
    let gender: Gender
    let forms: [SearchItemFormResponse]?
    
    // MARK: - Initializations
    
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
    
    // MARK: - Equatable
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.id != rhs.id
    }
    
    // MARK: - Mocks
    
    static var skiljaMock: Self? {
        MockManager.shared.loadFromJson(.skilja)
    }
    
    static var bananiMock: Self? {
        MockManager.shared.loadFromJson(.banani)
    }
    
    static var fallegurMock: Self? {
        MockManager.shared.loadFromJson(.fallegur)
    }
    
    static var skiljaOptionsMock: [Self] {
        MockManager.shared.loadFromJson(.skiljaOptions) ?? []
    }
    
    static var einnMock: Self? {
        MockManager.shared.loadFromJson(.einn)
    }
    
    static var hannMock: Self? {
        MockManager.shared.loadFromJson(.hann)
    }
    
    static var sigMock: Self? {
        MockManager.shared.loadFromJson(.sig)
    }
    
    static var leiðinlegaMock: Self? {
        MockManager.shared.loadFromJson(.leiðinlega)
    }
    
    static var annarMock: Self? {
        MockManager.shared.loadFromJson(.annar)
    }
}
