import XCTest
@testable import Snorrify

class ResponseTests: XCTestCase {}

// MARK: - Word Class Tests

extension ResponseTests {
    func testWordClassInitNoun() {
        let rawValue = "no"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .noun)
    }
    
    func testWordClassInitVerb() {
        let rawValue = "so"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .verb)
    }
    
    func testWordClassInitAdjective() {
        let rawValue = "lo"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .adjective)
    }
    
    func testWordClassInitReflexiveNoun() {
        let rawValue = "afn"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .reflexiveNoun)
    }
    
    func testWordClassInitAdverb() {
        let rawValue = "ao"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .adverb)
    }
    
    func testWordClassInitOtherPronoun() {
        let rawValue = "fn"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .otherPronoun)
    }
    
    func testWordClassInitPreposition() {
        let rawValue = "fs"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .preposition)
    }
    
    func testWordClassInitDefiniteArticle() {
        let rawValue = "gr"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .definiteArticle)
    }
    
    func testWordClassInitNominativeMarker() {
        let rawValue = "nhm"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .nominativeMarker)
    }
    
    func testWordClassInitPersonalPronoun() {
        let rawValue = "pfn"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .personalPronoun)
    }
    
    func testWordClassInitOrdinal() {
        let rawValue = "rt"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .ordinal)
    }
    
    func testWordClassInitConjunction() {
        let rawValue = "st"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .conjunction)
    }
    
    func testWordClassInitNumeral() {
        let rawValue = "to"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .numeral)
    }
    
    func testWordClassInitExclamation() {
        let rawValue = "uh"
        let wordClass = WordClass(rawValue: rawValue)
        XCTAssertTrue(wordClass != nil && wordClass == .exclamation)
    }
    
    func testWordClassAllCasesCount() {
        let expected = 14 + 1 // 14 - word classes, 1 – undefined.
        let reality = WordClass.allCases.count
        return XCTAssert(expected == reality)
    }
    
    func testWordClassCompareSameCases() {
        return XCTAssert(WordClass.noun == WordClass.noun)
    }
    
    func testWordClassCompareNotSameCases() {
        return XCTAssert(WordClass.noun != WordClass.verb)
    }
    
    func testWordClassInitUnknownRawValue() {
        XCTAssertNil(WordClass(rawValue: "Ivan"))
    }
}

// MARK: - Gender Tests

extension ResponseTests {
    func testGenderInitMasculine() {
        let rawValue = "kk"
        let gender = Gender(rawValue: rawValue)
        XCTAssert(gender != nil && gender == .masculine)
    }
    
    func testGenderInitFeminine() {
        let rawValue = "kvk"
        let gender = Gender(rawValue: rawValue)
        XCTAssert(gender != nil && gender == .feminine)
    }
    
    func testGenderInitNeuter() {
        let rawValue = "hk"
        let gender = Gender(rawValue: rawValue)
        XCTAssert(gender != nil && gender == .neuter)
    }
    
    func testGenderAllCasesCount() {
        let expected = 3 + 1 // 3 – genders, 1 – none.
        let reality = Gender.allCases.count
        XCTAssertEqual(expected, reality)
    }
    
    func testGenderCompareSameCases() {
        XCTAssertEqual(Gender.masculine, Gender.masculine)
    }
    
    func testGenderCompareNotSameCases() {
        XCTAssertFalse(Gender.masculine == Gender.feminine)
    }
    
    func testGenderInitUnknownRawValue() {
        XCTAssertNil(Gender(rawValue: "Ivan"))
    }
}
