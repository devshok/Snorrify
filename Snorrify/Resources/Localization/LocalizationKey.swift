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
            case header, button, footer
            
            var localizedString: String {
                "settings.cache.\(rawValue)".localized
            }
        }
        
        enum Data: String, LocalizationStringConvertible {
            case header, button, footer
            
            var localizedString: String {
                "settings.data.\(rawValue)".localized
            }
        }
        
        enum Feedback: String, LocalizationStringConvertible {
            case header, buttonRateApp, buttonContactDeveloper
            
            var localizedString: String {
                switch self {
                case .header:
                    return "settings.feedback.header".localized
                case .buttonRateApp:
                    return "settings.feedback.button.rateApp".localized
                case .buttonContactDeveloper:
                    return "settings.feedback.button.contactDeveloper".localized
                }
            }
        }
    }
}

// MARK: - Results Module

extension LocalizationKey {
    enum Results {
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
