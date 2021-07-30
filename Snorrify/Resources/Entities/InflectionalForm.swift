import Foundation

struct InflectionalForm: Identifiable, Hashable, Codable {
    let tag: String
    let word: String
    let number: Number
    let gender: Gender
    let grammarCase: GrammarCase
    let definiteArticle: DefiniteArticle
    let adjectiveDegree: AdjectiveDegree
    let conjugation: Conjugation
    let tense: Tense
    let verbVoice: VerbVoice
    let verbMood: VerbMood
    let person: Person
    
    var id: String { tag }
    
    init(tag: String, word: String) {
        self.tag = tag
        self.word = word
        self.number = Number(inflectionalTag: tag)
        self.gender = Gender(inflectionalTag: tag)
        self.grammarCase = GrammarCase(inflectionalTag: tag)
        self.definiteArticle = DefiniteArticle(inflectionalTag: tag)
        self.adjectiveDegree = AdjectiveDegree(inflectionalTag: tag)
        self.conjugation = Conjugation(inflectionalTag: tag)
        self.tense = Tense(inflectionalTag: tag)
        self.verbVoice = VerbVoice(inflectionalTag: tag)
        self.verbMood = VerbMood(inflectionalTag: tag)
        self.person = Person(inflectionalTag: tag)
    }
    
    var participle: Bool {
        tag.contains("LH") // lýsingarháttur
    }
    
    var supine: Bool {
        tag.contains("SAGNB") // sagnbót
    }
    
    var infinitive: Bool {
        tag.contains("NH") // nafnháttur
    }
    
    var impersonal: Bool {
        tag.contains("OP") // ópersónuleg
    }
}
