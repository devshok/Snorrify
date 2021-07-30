import Foundation

enum Tense: String, GrammarEnum {
    case present
    case past
    case none = ""
    
    init(inflectionalTag tag: String) {
        // nútíð:
        if tag.contains("NT") {
            self = .present
        }
        // þátíð:
        else if tag.contains("ÞT") {
            self = .past
        }
        else {
            self = .none
        }
    }
}
