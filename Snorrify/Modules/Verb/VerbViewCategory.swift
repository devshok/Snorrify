import Foundation

enum VerbViewCategory: Identifiable {
    case voice(Voice)
    case imperativeMood
    case supine
    case participle(Participle)
    
    enum Voice: Identifiable {
        case active, middle
        
        var id: String {
            switch self {
            case .active:
                return "1"
            case .middle:
                return "2"
            }
        }
    }
    
    enum Participle: Identifiable {
        case present, past
        
        var id: String {
            switch self {
            case .present:
                return "1"
            case .past:
                return "2"
            }
        }
    }
    
    var id: String {
        switch self {
        case .voice(let voiceType):
            return "1" + voiceType.id
        case .imperativeMood:
            return "2"
        case .supine:
            return "3"
        case .participle(let participleType):
            return "4" + participleType.id
        }
    }
}
