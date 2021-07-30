import Foundation

enum VerbMood: String, GrammarEnum {
    case indicative
    case subjunctive
    case imperative
    case none = ""
    
    init(inflectionalTag tag: String) {
        // framsöguháttur:
        if tag.contains("FH") {
            self = .indicative
        }
        // viðtengingarháttur:
        else if tag.contains("VH") {
            self = .subjunctive
        }
        // boðháttur:
        else if tag.contains("BH") {
            self = .imperative
        }
        else {
            self = .none
        }
    }
}
