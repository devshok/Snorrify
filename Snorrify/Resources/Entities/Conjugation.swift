import Foundation

enum Conjugation: String, GrammarEnum {
    case strong
    case weak
    case none = ""
    
    init(inflectionalTag tag: String) {
        // sterk beyging:
        if tag.contains("SB") || tag.contains("ESB") {
            self = .strong
        // veik beyging:
        } else if tag.contains("VB") {
            self = .weak
        } else {
            self = .none
        }
    }
}
