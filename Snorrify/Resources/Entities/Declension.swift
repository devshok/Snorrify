import Foundation

enum Declension: Int, GrammarEnum {
    case strong = 0
    case weak = 1
    case none = -1
    
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
