import Foundation

enum MockEntity: String, Identifiable, Hashable {
    case fallegur
    case banani
    case skilja
    case skiljaOptions
    case einn
    case hann
    case sig
    
    var id: String { rawValue }
    
    var resourceName: String {
        if self == .skiljaOptions {
            return "SkiljaOptions"
        } else {
            return rawValue.capitalized
        }
    }
}
