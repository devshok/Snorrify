import Foundation

enum WordClass: String, Codable, Identifiable, Hashable, CaseIterable {
    /// nafnorð
    case noun = "no"
    /// sagnorð
    case verb = "so"
    /// lýsingarorð
    case adjective = "lo"
    /// afturbeygt fornafn
    case reflexiveNoun = "afn"
    /// atviksorð
    case adverb = "ao"
    /// önnur fornöfn
    case otherPronoun = "fn"
    /// forsetningar
    case preposition = "fs"
    /// greinir
    case definiteArticle = "gr"
    /// nafnháttarmerki
    case nominativeMarker = "nhm"
    /// persónufornöfn
    case personalPronoun = "pfn"
    /// raðtölur
    case ordinal = "rt"
    /// samtengingar
    case conjunction = "st"
    /// töluorð
    case numeral = "to"
    /// upphrópanir
    case exclamation = "uh"
    /// unknown
    case none = ""
    
    var id: String { rawValue }
}
