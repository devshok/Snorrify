import Foundation

struct SearchItemFormResponse: Codable, Hashable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case inflectionalTag = "g" // String
        case word = "b" // String
    }
    
    var id: String { inflectionalTag }
    let inflectionalTag: String
    let word: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.inflectionalTag = try container.decode(String.self, forKey: .inflectionalTag)
        self.word = try container.decode(String.self, forKey: .word)
    }
}
