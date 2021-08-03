import Foundation

struct SearchItemFormResponse: Codable, Hashable, Identifiable {
    private enum CodingKeys: String, CodingKey {
        case inflectionalTag = "g" // String
        case word = "b" // String
    }
    
    var id: String { inflectionalTag }
    let inflectionalTag: String
    let word: String
    
    init(inflectionalTag: String, word: String) {
        self.inflectionalTag = inflectionalTag
        self.word = word
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.inflectionalTag = try container.decode(String.self, forKey: .inflectionalTag)
        self.word = try container.decode(String.self, forKey: .word)
    }
    
    var number: Number {
        Number(inflectionalTag: inflectionalTag)
    }
    
    var article: DefiniteArticle {
        DefiniteArticle(inflectionalTag: inflectionalTag)
    }
    
    var grammarCase: GrammarCase {
        GrammarCase(inflectionalTag: inflectionalTag)
    }
    
    static var bananiMockSingularForms: [Self] {
        return [
            .init(inflectionalTag: "NFET", word: "banani"),
            .init(inflectionalTag: "NFETgr", word: "bananinn"),
            .init(inflectionalTag: "ÞFET", word: "banana"),
            .init(inflectionalTag: "ÞFETgr", word: "bananann"),
            .init(inflectionalTag: "ÞGFET", word: "banana"),
            .init(inflectionalTag: "ÞGFETgr", word: "banananum"),
            .init(inflectionalTag: "EFET", word: "banana"),
            .init(inflectionalTag: "EFETgr", word: "bananans")
        ]
    }
    
    static var bananiMockPluralForms: [Self] {
        return [
            .init(inflectionalTag: "NFFT", word: "bananar"),
            .init(inflectionalTag: "NFFTgr", word: "bananarnir"),
            .init(inflectionalTag: "ÞFFT", word: "banana"),
            .init(inflectionalTag: "ÞFFTgr", word: "bananana"),
            .init(inflectionalTag: "ÞGFFT", word: "banönum"),
            .init(inflectionalTag: "ÞGFFTgr", word: "banönunum"),
            .init(inflectionalTag: "EFFT", word: "banana"),
            .init(inflectionalTag: "EFFTgr", word: "banananna")
        ]
    }
}
