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
    
    var tense: Tense {
        Tense(inflectionalTag: inflectionalTag)
    }
    
    var infinitive: Bool {
        inflectionalTag.contains("NH")
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
    
    static var skiljaMockForms: [Self] {
        return [
            .init(inflectionalTag: "GM-NH", word: "skilja"),
            .init(inflectionalTag: "GM-FH-NT-1P-ET", word: "skil"),
            .init(inflectionalTag: "GM-FH-NT-2P-ET", word: "skilur"),
            .init(inflectionalTag: "GM-FH-NT-3P-ET", word: "skilur"),
            .init(inflectionalTag: "GM-FH-NT-1P-FT", word: "skiljum"),
            .init(inflectionalTag: "GM-FH-NT-2P-FT", word: "skiljið"),
            .init(inflectionalTag: "GM-FH-NT-3P-FT", word: "skilja")
        ]
    }
}
