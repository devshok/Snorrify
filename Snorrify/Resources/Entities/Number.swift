import Foundation

enum Number: String, GrammarEnum {
    case singular
    case plural
    case none = ""
    
    init(inflectionalTag tag: String) {
        // eintala:
        if tag.contains("ET") {
            self = .singular
        }
        // fleirtala:
        else if tag.contains("FT") {
            self = .plural
        }
        else {
            self = .none
        }
    }
}
