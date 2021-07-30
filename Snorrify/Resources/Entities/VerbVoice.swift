import Foundation

enum VerbVoice: String, GrammarEnum {
    case active
    case middle
    case none = ""
    
    init(inflectionalTag tag: String) {
        // germynd:
        if tag.contains("GM") {
            self = .active
        }
        // miðmynd:
        else if tag.contains("MM") {
            self = .middle
        }
        else {
            self = .none
        }
    }
}
