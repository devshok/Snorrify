import Foundation

enum Gender: String, GrammarEnum {
    /// karlkynsnafnorð
    case masculine = "kk"
    /// kvenkynsnafnorð
    case feminine = "kvk"
    /// hvorugkynsnafnorð
    case neuter = "hk"
    /// unknown gender
    case none = ""
    
    init(inflectionalTag tag: String) {
        if tag.contains("KK") {
            self = .masculine
        }
        else if tag.contains("KVK") {
            self = .feminine
        }
        else if tag.contains("HK") {
            self = .neuter
        }
        else {
            self = .none
        }
    }
}
