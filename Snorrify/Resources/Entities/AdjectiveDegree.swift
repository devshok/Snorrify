import Foundation

enum AdjectiveDegree: String, GrammarEnum {
    case positive
    case comparative
    case superlative
    case none = ""
    
    init(inflectionalTag tag: String) {
        // frumstig || frumstig sterk beyging || frumstig veik beyging:
        if tag.contains("FST") || tag.contains("FSB") || tag.contains("FVB") {
            self = .positive
        }
        // miðstig:
        else if tag.contains("MST") {
            self = .comparative
        }
        // efsta stig || efsta stig sterk beyging || efsta stig veik beyging:
        else if tag.contains("EST") || tag.contains("ESB") || tag.contains("EVB") {
            self = .superlative
        }
        else {
            self = .none
        }
    }
}
