import Foundation

enum GrammarCase: String, GrammarEnum, CaseIterable {
    case nominative
    case accusative
    case dative
    case genitive
    case none = ""
    
    init(inflectionalTag tag: String) {
        // nefnifall:
        if tag.contains("NF") {
            self = .nominative
        }
        // þolfall:
        else if tag.contains("ÞF") {
            self = .accusative
        }
        // þágufall:
        else if tag.contains("ÞGF") {
            self = .dative
        }
        // eignarfall:
        else if tag.contains("EF") {
            self = .genitive
        } else {
            self = .none
        }
    }
    
    var priority: Int {
        switch self {
        case .nominative:
            return 4
        case .accusative:
            return 3
        case .dative:
            return 2
        case .genitive:
            return 1
        case .none:
            return 0
        }
    }
}
