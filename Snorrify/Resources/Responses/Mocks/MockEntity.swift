import Foundation

enum MockEntity: String, Identifiable, Hashable {
    case fallegur
    case banani
    case skilja
    case skiljaOptions
    case einn
    
    var id: String { rawValue }
    
    var resourceName: String {
        switch self {
        case .fallegur, .banani, .skilja, .einn:
            return rawValue.capitalized
        case .skiljaOptions:
            return "SkiljaOptions"
        }
    }
}
