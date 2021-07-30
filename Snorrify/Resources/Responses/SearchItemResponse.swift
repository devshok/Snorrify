import Foundation

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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.word = try container.decode(String.self, forKey: .word)
        self.wordClass = try container.decode(WordClass.self, forKey: .wordClass)
        self.gender = try container.decode(Gender.self, forKey: .gender)
        self.forms = try? container.decodeIfPresent([SearchItemFormResponse].self, forKey: .forms)
    }
}
