import Foundation

enum Person: String, GrammarEnum {
    case first
    case second
    case third
    case none = ""
    
    init(inflectionalTag tag: String) {
        // 1. persóna:
        if tag.contains("1P") {
            self = .first
        }
        // 2. persóna:
        else if tag.contains("2P") {
            self = .second
        }
        // 3. persóna:
        else if tag.contains("3P") {
            self = .third
        }
        else {
            self = .none
        }
    }
}
