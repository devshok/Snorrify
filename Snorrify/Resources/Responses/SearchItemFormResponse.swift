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
        inflectionalTag.contains(String.impersonalTag)
    }
    
    var questionable: Bool {
        inflectionalTag.contains(String.questionTag)
    }
    
    var rootable: Bool {
        inflectionalTag.contains(String.rootTag)
    }
    
    var supine: Bool {
        inflectionalTag.contains(String.supineTag)
    }
    
    var participle: Bool {
        inflectionalTag.contains(String.participleTag)
    }
    
    var conjugation: Conjugation {
        Conjugation(inflectionalTag: inflectionalTag)
    }
    
    var declension: Declension {
        Declension(inflectionalTag: inflectionalTag)
    }
    
    var adjectiveDegree: AdjectiveDegree {
        AdjectiveDegree(inflectionalTag: inflectionalTag)
    }
}
