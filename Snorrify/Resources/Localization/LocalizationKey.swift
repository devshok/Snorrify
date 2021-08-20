import Foundation

enum LocalizationKey: LocalizationStringConvertible {
    
    // MARK: - Terms
    
    case search
    case loading
    case `for`(word: String)
    case favorites
    case settings
    case noResults
    case lastResults
    case whichOne
    case error
    case empty
    case close
    case chooseCategory
    case infinitive
    case moods
    case gender
    case genders
    case pronounYouSingularTip
    case pronounYouPluralTip
    case verbRoot
    case declensions
    case singularForms
    case pluralForms
    case ok
    case yes
    case no
    case device
    case mail(_ body: String, _ firstDomain: String, _ secondDomain: String)
    case mailSubject
    case tryLater
    case and
    
    var localizedString: String {
        switch self {
        case .search:
            return "search".localized
        case .loading:
            return "loading".localized
        case .for(let word):
            return "for".localized(args: word)
        case .favorites:
            return "favorites".localized
        case .settings:
            return "settings".localized
        case .noResults:
            return "noResults".localized
        case .lastResults:
            return "lastResults".localized
        case .whichOne:
            return "whichOne".localized
        case .error:
            return "error".localized
        case .empty:
            return "empty".localized
        case .close:
            return "close".localized
        case .chooseCategory:
            return "chooseCategory".localized
        case .infinitive:
            return "infinitive".localized
        case .moods:
            return "moods".localized
        case .gender:
            return "gender".localized
        case .genders:
            return "genders".localized
        case .pronounYouSingularTip:
            return "pronounYouSingularTip".localized
        case .pronounYouPluralTip:
            return "pronounYouPluralTip".localized
        case .verbRoot:
            return "verbRoot".localized
        case .declensions:
            return "declensions".localized
        case .singularForms:
            return "singularForms".localized
        case .pluralForms:
            return "pluralForms".localized
        case .ok:
            return "ok".localized
        case .yes:
            return "yes".localized
        case .no:
            return "no".localized
        case .device:
            return "device".localized
        case let .mail(body, firstDomain, secondDomain):
            return "mail".localized(args: body, firstDomain, secondDomain)
        case .mailSubject:
            return "mailSubject".localized
        case .tryLater:
            return "tryLater".localized
        case .and:
            return "and".localized
        }
    }
    
    // MARK: - No Forms
    
    enum NoForms: String, LocalizationStringConvertible {
        case title, description
        
        var localizedString: String {
            "noForms.\(rawValue)".localized
        }
    }
}

// MARK: - Search Module

extension LocalizationKey {
    enum Search {
        enum Placeholder: String, LocalizationStringConvertible {
            case title
            case description
            case tryAnotherSearch
            
            var localizedString: String {
                "search.placeholder.\(rawValue)".localized
            }
        }
    }
}

// MARK: - Favorites Module

extension LocalizationKey {
    enum Favorites: String, LocalizationStringConvertible {
        case placeholderDescription
        
        var localizedString: String {
            "favorites.\(rawValue)".localized
        }
    }
}

// MARK: - Settings Module

extension LocalizationKey {
    enum Settings {
        
        enum Cache: String, LocalizationStringConvertible {
            case header
            case button
            case footer
            
            var localizedString: String {
                "settings.cache.\(rawValue)".localized
            }
            
            enum ClearCacheAlert: String, LocalizationStringConvertible {
                case question, confirmation
                
                var localizedString: String {
                    "settings.cache.clearCacheAlert.\(rawValue)".localized
                }
            }
        }
        
        enum Data: String, LocalizationStringConvertible {
            case header
            case button
            case footer
            
            var localizedString: String {
                "settings.data.\(rawValue)".localized
            }
            
            enum RemoveFavoritesAlert: String, LocalizationStringConvertible {
                case question, confirmation
                
                var localizedString: String {
                    "settings.data.removeFavoritesAlert.\(rawValue)".localized
                }
            }
        }
        
        enum Feedback: String, LocalizationStringConvertible {
            case header
            
            var localizedString: String {
                "settings.feedback.\(rawValue)".localized
            }
            
            enum Button: String, LocalizationStringConvertible {
                case rateApp, contactDeveloper
                
                var localizedString: String {
                    "settings.feedback.button.\(rawValue)".localized
                }
            }
            
            enum Alert: String, LocalizationStringConvertible {
                case sentMail, failedSendMail
                
                var localizedString: String {
                    "settings.feedback.alert.\(rawValue)".localized
                }
            }
        }
    }
}

// MARK: - Results Module

extension LocalizationKey {
    enum Results: String, LocalizationStringConvertible {
        case singularForms
        case pluralForms
        
        var localizedString: String {
            "results.\(rawValue)".localized
        }
        
        enum Option: String, LocalizationStringConvertible {
            
            enum Noun: String, LocalizationStringConvertible {
                case neuter, feminine, masculine
                
                var localizedString: String {
                    ("results.option.noun." + rawValue).localized
                }
            }
            
            case verb
            case adjective
            case reflexivePronoun
            case adverb
            case otherPronoun
            case preposition
            case definiteArticle
            case nominativeMarker
            case personalPronoun
            case ordinal
            case conjunction
            case numeral
            case exclamation
            
            var localizedString: String {
                "results.option.\(rawValue)".localized
            }
        }
        
        enum Article: String, LocalizationStringConvertible {
            case yes, no
            
            var localizedString: String {
                "results.article.\(rawValue)".localized
            }
        }
        
        enum NoFormsForThis: LocalizationStringConvertible {
            case prefix(Postfix)
            
            var localizedString: String {
                switch self {
                case .prefix(let postfix):
                    return "results.noFormsForThis.prefix"
                        .localized(args: postfix.localizedString)
                }
            }
            
            enum Postfix: String, LocalizationStringConvertible {
                case adverb
                case article
                case nominativeMarker
                case conjunction
                case exclamation
                case preposition
                case word
                
                var localizedString: String {
                    "results.noFormsForThis.postfix.\(rawValue)".localized
                }
            }
        }
    }
}

// MARK: - Errors

extension LocalizationKey {
    enum NetworkError: String, LocalizationStringConvertible {
        case unknown
        case cancelledRequest
        case badRequest
        case timedOut
        case serverUnavailable
        case noInternet
        case badInternet
        case notFound
        case badResponse
        
        var localizedString: String {
            "networkError.\(rawValue)".localized
        }
    }
}

// MARK: - Grammar

extension LocalizationKey {
    enum Grammar {
        enum GrammarCase: String, LocalizationStringConvertible {
            case nominative
            case accusative
            case dative
            case genitive
            
            var localizedString: String {
                "grammar.grammarCase.\(rawValue)".localized
            }
        }
        
        // MARK: - Verb
        
        enum Verb: String, LocalizationStringConvertible {
            case infinitivePrefix
            
            var localizedString: String {
                "grammar.verb.\(rawValue)".localized
            }
            
            enum ActiveVoice: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.verb.activeVoice.\(rawValue)".localized
                }
            }
            
            enum MiddleVoice: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.verb.middleVoice.\(rawValue)".localized
                }
            }
            
            enum ImperativeMood: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.verb.imperativeMood.\(rawValue)".localized
                }
            }
            
            enum Supine: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.verb.supine.\(rawValue)".localized
                }
            }
            
            enum Participle {
                enum Present: String, LocalizationStringConvertible {
                    case native, translated
                    
                    var localizedString: String {
                        "grammar.verb.participle.present.\(rawValue)".localized
                    }
                }
                
                enum Past: String, LocalizationStringConvertible {
                    case native, translated
                    
                    var localizedString: String {
                        "grammar.verb.participle.past.\(rawValue)".localized
                    }
                }
            }
            
            enum Mood: String, LocalizationStringConvertible {
                case indicative, subjunctive
                
                var localizedString: String {
                    "grammar.verb.mood.\(rawValue)".localized
                }
            }
            
            enum Tense: String, LocalizationStringConvertible {
                case present, past
                
                var localizedString: String {
                    "grammar.verb.tense.\(rawValue)".localized
                }
            }
        }
        
        // MARK: - Number
        
        enum Number: String, LocalizationStringConvertible {
            case singular, plural
            
            var localizedString: String {
                "grammar.number.\(rawValue)".localized
            }
        }
        
        // MARK: - Gender
        
        enum Gender: String, LocalizationStringConvertible {
            case masculine, feminine, neuter
            
            var localizedString: String {
                "grammar.gender.\(rawValue)".localized
            }
        }
        
        // MARK: - Pronoun
        
        enum Pronoun {
            enum Me: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.pronoun.me.\(rawValue)".localized
                }
            }
            
            enum You {
                enum Singular: String, LocalizationStringConvertible {
                    case native, translated
                    
                    var localizedString: String {
                        "grammar.pronoun.you.singular.\(rawValue)".localized
                    }
                }
                
                enum Plural: String, LocalizationStringConvertible {
                    case native, translated
                    
                    var localizedString: String {
                        "grammar.pronoun.you.plural.\(rawValue)".localized
                    }
                }
            }
            
            enum He: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.pronoun.he.\(rawValue)".localized
                }
            }
            
            enum She: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.pronoun.she.\(rawValue)".localized
                }
            }
            
            enum That: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.pronoun.that.\(rawValue)".localized
                }
            }
            
            enum They {
                enum Masculine: String, LocalizationStringConvertible {
                    case native, translated
                    
                    var localizedString: String {
                        "grammar.pronoun.they.masculine.\(rawValue)".localized
                    }
                }
                
                enum Feminine: String, LocalizationStringConvertible {
                    case native, translated
                    
                    var localizedString: String {
                        "grammar.pronoun.they.feminine.\(rawValue)".localized
                    }
                }
                
                enum Neuter: String, LocalizationStringConvertible {
                    case native, translated
                    
                    var localizedString: String {
                        "grammar.pronoun.they.neuter.\(rawValue)".localized
                    }
                }
            }
            
            enum We: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.pronoun.we.\(rawValue)".localized
                }
            }
        }
        
        enum Declension: String, LocalizationStringConvertible {
            case strong, weak
            
            var localizedString: String {
                "grammar.declension.\(rawValue)".localized
            }
        }
    }
    
    // MARK: - Adjective
    
    enum Adjective {
        enum Degree {
            enum Positive: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.adjective.degree.positive.\(rawValue)".localized
                }
            }
            
            enum Comparative: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.adjective.degree.comparative.\(rawValue)".localized
                }
            }
            
            enum Superlative: String, LocalizationStringConvertible {
                case native, translated
                
                var localizedString: String {
                    "grammar.adjective.degree.superlative.\(rawValue)".localized
                }
            }
        }
    }
}
