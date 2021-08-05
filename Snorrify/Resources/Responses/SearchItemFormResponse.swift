import Foundation

struct SearchItemFormResponse: Codable, Hashable, Identifiable {
    // MARK: - Coding Keys
    
    private enum CodingKeys: String, CodingKey {
        case inflectionalTag = "g" // String
        case word = "b" // String
    }
    
    // MARK: - Properties
    
    var id: String { inflectionalTag }
    let inflectionalTag: String
    let word: String
    
    // MARK: - Initializations
    
    init(inflectionalTag: String, word: String) {
        self.inflectionalTag = inflectionalTag
        self.word = word
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.inflectionalTag = try container.decode(String.self, forKey: .inflectionalTag)
        self.word = try container.decode(String.self, forKey: .word)
    }
    
    // MARK: - Grammar Getters
    
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
    
    var verbVoice: VerbVoice {
        VerbVoice(inflectionalTag: inflectionalTag)
    }
    
    var mood: VerbMood {
        VerbMood(inflectionalTag: inflectionalTag)
    }
    
    var gender: Gender {
        Gender(inflectionalTag: inflectionalTag)
    }
    
    var person: Person {
        Person(inflectionalTag: inflectionalTag)
    }
    
    var pronoun: Pronoun {
        Pronoun(number: number, person: person, gender: gender)
    }
    
    var impersonal: Bool {
        // ópersonulegur:
        inflectionalTag.contains("OP")
    }
    
    var questionable: Bool {
        // spurnamynd:
        inflectionalTag.contains("SP")
    }
    
    var rootable: Bool {
        // stýfður:
        inflectionalTag.contains("ST")
    }
    
    var supine: Bool {
        // sagnbót:
        inflectionalTag.contains("SAGNB")
    }
    
    var participle: Bool {
        // lýsingarháttur:
        inflectionalTag.contains("LH")
    }
    
    var conjugation: Conjugation {
        Conjugation(inflectionalTag: inflectionalTag)
    }
    
    var declension: Declension {
        Declension(inflectionalTag: inflectionalTag)
    }
    
    // MARK: - Mocks
    
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
    
    static var skiljaImperativeFormsMock: [Self] {
        return [
            .init(inflectionalTag: "GM-BH-ST", word: "skil"),
            .init(inflectionalTag: "GM-BH-ET", word: "skildu"),
            .init(inflectionalTag: "GM-BH-FT", word: "skiljið")
        ]
    }
    
    static var skiljaSupineFormsMock: [Self] {
        return [
            .init(inflectionalTag: "GM-SAGNB", word: "skilið"),
            .init(inflectionalTag: "MM-SAGNB", word: "skilist")
        ]
    }
    
    static var skiljaPresentParticipleFormMock: Self {
        .init(inflectionalTag: "LHNT", word: "skiljandi")
    }
}
