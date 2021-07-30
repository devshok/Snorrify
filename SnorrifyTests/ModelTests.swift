import XCTest
@testable import Snorrify

class ModelTests: XCTestCase {}

// MARK: - Number Tests

extension ModelTests {
    func testNumberInitSingular() {
        let rawValue = "singular"
        let number = Number(rawValue: rawValue)
        XCTAssert(number != nil && number == .singular)
    }
    
    func testNumberInitPlural() {
        let rawValue = "plural"
        let number = Number(rawValue: rawValue)
        XCTAssert(number != nil && number == .plural)
    }
    
    func testNumberInitUnknownRawValue() {
        let rawValue = "Ivan"
        let number = Number(rawValue: rawValue)
        XCTAssertNil(number)
    }
    
    func testNumberCompareSameCases() {
        XCTAssertEqual(Number.singular, Number.singular)
    }
    
    func testNumberCompareNotSameCases() {
        XCTAssertNotEqual(Number.singular, Number.plural)
    }
    
    func testNumberAllCasesCount() {
        let expected = 2 + 1 // 2 – numbers, 1 – none.
        let reality = Number.allCases.count
        XCTAssertEqual(expected, reality)
    }
}

// MARK: - Grammar Case Test

extension SnorrifyTests {
    func testGrammarCaseInitNominative() {
        let rawValue = "nominative"
        let grammarCase = GrammarCase(rawValue: rawValue)
        XCTAssert(grammarCase != nil && grammarCase == .nominative)
    }
    
    func testGrammarCaseInitAccusative() {
        let rawValue = "accusative"
        let grammarCase = GrammarCase(rawValue: rawValue)
        XCTAssert(grammarCase != nil && grammarCase == .accusative)
    }
    
    func testGrammarCaseInitDative() {
        let rawValue = "dative"
        let grammarCase = GrammarCase(rawValue: rawValue)
        XCTAssert(grammarCase != nil && grammarCase == .dative)
    }
    
    func testGrammarCaseInitGenitive() {
        let rawValue = "genitive"
        let grammarCase = GrammarCase(rawValue: rawValue)
        XCTAssert(grammarCase != nil && grammarCase == .genitive)
    }
    
    func testGrammarCaseInitUnknownRawValue() {
        let rawValue = "Ivan"
        let grammarCase = GrammarCase(rawValue: rawValue)
        XCTAssertNil(grammarCase)
    }
    
    func testGrammarCaseCompareSameCases() {
        XCTAssertEqual(GrammarCase.nominative, GrammarCase.nominative)
    }
    
    func testGrammarCaseCompareNotSameCases() {
        XCTAssertNotEqual(GrammarCase.none, GrammarCase.dative)
    }
    
    func testGrammarCaseAllCasesCount() {
        let expected = 4 + 1 // 4 – grammar cases, 1 – none
        let reality = GrammarCase.allCases.count
        XCTAssertEqual(expected, reality)
    }
}

// MARK: - Definite Article Tests

extension ModelTests {
    func testDefiniteArticleInitYes() {
        let rawValue = "yes"
        let definiteArticle = DefiniteArticle(rawValue: rawValue)
        XCTAssert(definiteArticle != nil && definiteArticle == .yes)
    }
    
    func testDefiniteArticleInitNo() {
        let rawValue = "no"
        let definiteArticle = DefiniteArticle(rawValue: rawValue)
        XCTAssert(definiteArticle != nil && definiteArticle == .no)
    }
    
    func testDefiniteArticleInitUnknownRawValue() {
        let rawValue = "Ivan"
        let definiteArticle = DefiniteArticle(rawValue: rawValue)
        XCTAssertNil(definiteArticle)
    }
}

// MARK: - Adjective Degree Tests

extension ModelTests {
    func testAdjectiveDegreeInitPositive() {
        let rawValue = "positive"
        let adjectiveDegree = AdjectiveDegree(rawValue: rawValue)
        XCTAssert(adjectiveDegree != nil && adjectiveDegree == .positive)
    }
    
    func testAdjectiveDegreeInitComparative() {
        let rawValue = "comparative"
        let adjectiveDegree = AdjectiveDegree(rawValue: rawValue)
        XCTAssert(adjectiveDegree != nil && adjectiveDegree == .comparative)
    }
    
    func testAdjectiveDegreeInitSuperlative() {
        let rawValue = "superlative"
        let adjectiveDegree = AdjectiveDegree(rawValue: rawValue)
        XCTAssert(adjectiveDegree != nil && adjectiveDegree == .superlative)
    }
    
    func testAdjectiveDegreeInitUnknownRawValue() {
        let rawValue = "Ivan"
        let adjectiveDegree = AdjectiveDegree(rawValue: rawValue)
        XCTAssertNil(adjectiveDegree)
    }
    
    func testAdjectiveDegreeAllCasesCount() {
        let expected = 3 + 1 // 3 - degrees, 1 – none
        let reality = AdjectiveDegree.allCases.count
        XCTAssertEqual(expected, reality)
    }
    
    func testAdjectiveDegreeCompareSameCases() {
        XCTAssertEqual(AdjectiveDegree.comparative, AdjectiveDegree.comparative)
    }
    
    func testAdjectiveDegreeCompareNotSameCases() {
        XCTAssertNotEqual(AdjectiveDegree.comparative, AdjectiveDegree.superlative)
    }
}

// MARK: - Conjugation Tests

extension ModelTests {
    func testConjugationInitStrong() {
        let rawValue = "strong"
        let conjugation = Conjugation(rawValue: rawValue)
        XCTAssert(conjugation != nil && conjugation == .strong)
    }
    
    func testConjugationInitWeak() {
        let rawValue = "weak"
        let conjugation = Conjugation(rawValue: rawValue)
        XCTAssert(conjugation != nil && conjugation == .weak)
    }
    
    func testConjugationInitUnknownRawValue() {
        let rawValue = "Ivan"
        let conjugation = Conjugation(rawValue: rawValue)
        XCTAssertNil(conjugation)
    }
    
    func testConjugationAllCasesCount() {
        let expected = 2 + 1 // 2 - conjugations, 1 - none.
        let reality = Conjugation.allCases.count
        XCTAssertEqual(expected, reality)
    }
    
    func testConjugationCompareSameCases() {
        XCTAssertEqual(Conjugation.weak, Conjugation.weak)
    }
    
    func testConjugationCompareNotSameCases() {
        XCTAssertNotEqual(Conjugation.weak, Conjugation.strong)
    }
}

// MARK: - Tense Tests

extension ModelTests {
    func testTenseInitPresent() {
        let rawValue = "present"
        let tense = Tense(rawValue: rawValue)
        XCTAssert(tense != nil && tense == .present)
    }
    
    func testTenseInitPast() {
        let rawValue = "past"
        let tense = Tense(rawValue: rawValue)
        XCTAssert(tense != nil && tense == .past)
    }
    
    func testTenseInitUnknownRawValue() {
        let rawValue = "Ivan"
        let tense = Tense(rawValue: rawValue)
        XCTAssertNil(tense)
    }
    
    func testTenseAllCasesCount() {
        let expected = 2 + 1 // 2 - tenses, 1 - none.
        let reality = Tense.allCases.count
        XCTAssertEqual(expected, reality)
    }
    
    func testTenseCompareSameCases() {
        XCTAssertEqual(Tense.past, Tense.past)
    }
    
    func testTenseCompareNotSameCases() {
        XCTAssertNotEqual(Tense.past, Tense.present)
    }
}

// MARK: - Verb Voice Test

extension ModelTests {
    func testVerbVoiceInitActive() {
        let rawValue = "active"
        let verbVoice = VerbVoice(rawValue: rawValue)
        XCTAssert(verbVoice != nil && verbVoice == .active)
    }
    
    func testVerbVoiceInitMiddle() {
        let rawValue = "middle"
        let verbVoice = VerbVoice(rawValue: rawValue)
        XCTAssert(verbVoice != nil && verbVoice == .middle)
    }
    
    func testVerbVoiceInitUnknownRawValue() {
        let rawValue = "Ivan"
        let verbVoice = VerbVoice(rawValue: rawValue)
        XCTAssertNil(verbVoice)
    }
    
    func testVerbVoiceAllCasesCount() {
        let expected = 2 + 1 // 2 - voices, 1 - none.
        let reality = VerbVoice.allCases.count
        XCTAssertEqual(expected, reality)
    }
    
    func testVerbVoiceCompareSameCases() {
        XCTAssertEqual(VerbVoice.active, VerbVoice.active)
    }
    
    func testVerbVoiceCompareNotSameCases() {
        XCTAssertNotEqual(VerbVoice.active, VerbVoice.middle)
    }
}

// MARK: - Verb Mood Tests

extension ModelTests {
    func testVerbMoodInitIndicative() {
        let rawValue = "indicative"
        let verbMood = VerbMood(rawValue: rawValue)
        XCTAssert(verbMood != nil && verbMood == .indicative)
    }
    
    func testVerbMoodInitSubjunctive() {
        let rawValue = "subjunctive"
        let verbMood = VerbMood(rawValue: rawValue)
        XCTAssert(verbMood != nil && verbMood == .subjunctive)
    }
    
    func testVerbMoodInitUnknownRawValue() {
        let rawValue = "Ivan"
        let verbMood = VerbMood(rawValue: rawValue)
        XCTAssertNil(verbMood)
    }
    
    func testVerbMoodAllCasesCount() {
        let expected = 3 + 1 // 3 - moods, 1 - none.
        let reality = VerbMood.allCases.count
        XCTAssertEqual(expected, reality)
    }
    
    func testVerbMoodCompareSameCases() {
        XCTAssertEqual(VerbMood.imperative, VerbMood.imperative)
    }
    
    func testVerbMoodCompareNotSameCases() {
        XCTAssertNotEqual(VerbMood.imperative, VerbMood.indicative)
    }
}

// MARK: - Person Tests

extension ModelTests {
    func testPersonInitFirst() {
        let rawValue = "first"
        let person = Person(rawValue: rawValue)
        XCTAssert(person != nil && person == .first)
    }
    
    func testPersonInitSecond() {
        let rawValue = "second"
        let person = Person(rawValue: rawValue)
        XCTAssert(person != nil && person == .second)
    }
    
    func testPersonInitThird() {
        let rawValue = "third"
        let person = Person(rawValue: rawValue)
        XCTAssert(person != nil && person == .third)
    }
    
    func testPersonInitUnknownRawValue() {
        let rawValue = "Ivan"
        let person = Person(rawValue: rawValue)
        XCTAssertNil(person)
    }
    
    func testPersonAllCasesCount() {
        let expected = 3 + 1 // 3 - persons, 1 - none.
        let reality = Person.allCases.count
        XCTAssertEqual(expected, reality)
    }
    
    func testPersonCompareSameCases() {
        XCTAssertEqual(Person.first, Person.first)
    }
    
    func testPersonCompareNotSameCases() {
        XCTAssertNotEqual(Person.first, Person.second)
    }
}
