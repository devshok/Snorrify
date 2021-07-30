import Foundation

enum DefiniteArticle: String, GrammarEnum {
    case yes
    case no
    
    init(inflectionalTag tag: String) {
        // greinir:
        if tag.contains("gr") {
            self = .yes
        } else {
            self = .no
        }
    }
}
