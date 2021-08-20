import Foundation

enum MockEntity: String, Identifiable, Hashable {
    case fallegur
    case banani
    case skilja
    case skiljaOptions
    case einnNumeral
    case einnOtherPronoun
    case hann
    case sig
    case leiðinlega
    case annar
    
    var id: String { rawValue }
    
    var resourceName: String {
        switch self {
        case .skiljaOptions:
            return "SkiljaOptions"
        case .einnNumeral:
            return "Einn_Numeral"
        case .einnOtherPronoun:
            return "Einn_Other_Pronoun"
        default:
            return rawValue.capitalized
        }
    }
}
