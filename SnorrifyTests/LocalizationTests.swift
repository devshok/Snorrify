import XCTest
@testable import Snorrify

class LocalizationTests: XCTestCase {
    
    // MARK: - Aliases
    
    private typealias LK = LocalizationKey
}

// MARK: - Terms

extension LocalizationTests {
    func testTermsSearch() {
        XCTAssert("search" == LK.search.localizedString)
    }
    
    func testTermsLoading() {
        XCTAssert("loading.." == LK.loading.localizedString)
    }
    
    func testTermsFor() {
        let word = "skilja"
        XCTAssert("for \"\(word)\"" == LK.for(word: word).localizedString)
    }
    
    func testTermsFavorites() {
        XCTAssert("favorites" == LK.favorites.localizedString)
    }
    
    func testTermsSettings() {
        XCTAssert("settings" == LK.settings.localizedString)
    }
    
    func testTermsNoResults() {
        XCTAssert("no results" == LK.noResults.localizedString)
    }
    
    func testTermsLastResults() {
        XCTAssert("last results" == LK.lastResults.localizedString)
    }
    
    func testTermsWhichOne() {
        XCTAssert("which one?" == LK.whichOne.localizedString)
    }
    
    func testTermsError() {
        XCTAssert("error" == LK.error.localizedString)
    }
    
    func testTermsEmpty() {
        XCTAssert("empty" == LK.empty.localizedString)
    }
    
    func testTermsClose() {
        XCTAssert("close" == LK.close.localizedString)
    }
}

// MARK: - Search Module

extension LocalizationTests {
    func testSearchPlaceholderTitle() {
        XCTAssert("start exploring!" == LK.Search.Placeholder.title.localizedString)
    }
    
    func testSearchPlaceholderDescription() {
        let string: String = {
            return "just type any Icelandic word to check all its forms."
        }()
        XCTAssert(string == LK.Search.Placeholder.description.localizedString)
    }
    
    func testSearchPlaceholderDescriptionTryAnotherSearch() {
        let result: String = {
            return "try another search."
        }()
        let expected = LK.Search.Placeholder.tryAnotherSearch.localizedString
        XCTAssertEqual(result, expected)
    }
}

// MARK: - Favorites Module

extension LocalizationTests {
    func testFavoritesPlaceholderDescription() {
        let string: String = {
            return "add necessary words here to review in any time."
        }()
        XCTAssertEqual(string, LK.Favorites.placeholderDescription.localizedString)
    }
}

// MARK: - Settings

extension LocalizationTests {
    private typealias CacheLK = LK.Settings.Cache
    private typealias DataLK = LK.Settings.Data
    private typealias FeedbackLK = LK.Settings.Feedback
    
    func testSettingsCacheHeader() {
        XCTAssertEqual("cache", CacheLK.header.localizedString)
    }
    
    func testSettingsCacheButton() {
        XCTAssertEqual("clear cache", CacheLK.button.localizedString)
    }
    
    func testSettingsCacheFooter() {
        let string: String = {
            return "cache helps you to make app faster but it tends to increase the size of itself while you search more and more words."
        }()
        XCTAssertEqual(string, CacheLK.footer.localizedString)
    }
    
    func testSettingsDataHeader() {
        XCTAssertEqual("data", DataLK.header.localizedString)
    }
    
    func testSettingsDataButton() {
        XCTAssertEqual("remove favorites list", DataLK.button.localizedString)
    }
    
    func testSettingsDataFooter() {
        let string: String = {
            return "favorites list is all the words you added earlier to review them in any time later."
        }()
        XCTAssertEqual(string, DataLK.footer.localizedString)
    }
    
    func testSettingsFeedbackHeader() {
        XCTAssertEqual("feedback", FeedbackLK.header.localizedString)
    }
    
    func testSettingsFeedbackButtonRateApp() {
        XCTAssertEqual("rate app", FeedbackLK.buttonRateApp.localizedString)
    }
    
    func testSettingsFeedbackButtonContactDeveloper() {
        let expected = FeedbackLK.buttonContactDeveloper.localizedString
        XCTAssertEqual("contact developer", expected)
    }
}

// MARK: - Results Module

extension LocalizationTests {
    
    private typealias OptionLK = LK.Results.Option
    
    func testResultsOptionNounNeuter() {
        XCTAssertEqual("neuter noun", OptionLK.Noun.neuter.localizedString)
    }
    
    func testResultsOptionNounFeminine() {
        XCTAssertEqual("feminine noun", OptionLK.Noun.feminine.localizedString)
    }
    
    func testResultsOptionNounMasculine() {
        XCTAssertEqual("masculine noun", OptionLK.Noun.masculine.localizedString)
    }
    
    func testResultsOptionVerb() {
        XCTAssertEqual("verb", OptionLK.verb.localizedString)
    }
    
    func testResultsOptionAdjective() {
        XCTAssertEqual("adjective", OptionLK.adjective.localizedString)
    }
    
    func testResultsOptionReflexivePronoun() {
        XCTAssertEqual("reflexive pronoun", OptionLK.reflexivePronoun.localizedString)
    }
    
    func testResultsOptionAdverb() {
        XCTAssertEqual("adverb", OptionLK.adverb.localizedString)
    }
    
    func testResultsOptionOtherPronoun() {
        XCTAssertEqual("other pronoun", OptionLK.otherPronoun.localizedString)
    }
    
    func testResultsOptionPreposition() {
        XCTAssertEqual("preposition", OptionLK.preposition.localizedString)
    }
    
    func testResultsOptionDefiniteArticle() {
        let result = "the definite article"
        let expected = OptionLK.definiteArticle.localizedString
        XCTAssertEqual(result, expected)
    }
    
    func testResultsOptionNominativeArticle() {
        let result = "the nominative marker"
        let expected = OptionLK.nominativeMarker.localizedString
        XCTAssertEqual(result, expected)
    }
    
    func testResultsOptionPersonalPronoun() {
        let result = "personal pronoun"
        let expected = OptionLK.personalPronoun.localizedString
        XCTAssertEqual(result, expected)
    }
    
    func testResultsOptionOrdinal() {
        let result = "ordinal"
        let expected = OptionLK.ordinal.localizedString
        XCTAssertEqual(result, expected)
    }
    
    func testResultsOptionConjunction() {
        let result = "conjunction"
        let expected = OptionLK.conjunction.localizedString
        XCTAssertEqual(result, expected)
    }
    
    func testResultsOptionNumeral() {
        let result = "numeral"
        let expected = OptionLK.numeral.localizedString
        XCTAssertEqual(result, expected)
    }
    
    func testResultsOptionExclamation() {
        let result = "exclamation"
        let expected = OptionLK.exclamation.localizedString
        XCTAssertEqual(result, expected)
    }
}
