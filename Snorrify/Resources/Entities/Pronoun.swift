import Foundation

enum Pronoun: Equatable {
    case me
    case we
    case you(Number)
    case he, she, it
    case they
    case none
    
    var priority: Int {
        switch self {
        case .me:
            return 6
        case .you(.singular):
            return 5
        case .he, .she, .it:
            return 4
        case .we:
            return 3
        case .you(.plural):
            return 2
        case .they:
            return 1
        case .you(.none), .none:
            return .zero
        }
    }
    
    init(number: Number, person: Person, gender: Gender = .none) {
        switch person {
        case .first:
            switch number {
            case .singular:
                self = .me
            case .plural:
                self = .we
            case .none:
                self = .none
            }
        case .second:
            switch number {
            case .singular:
                self = .you(.singular)
            case .plural:
                self = .you(.plural)
            case .none:
                self = .none
            }
        case .third:
            switch number {
            case .singular:
                switch gender {
                case .masculine:
                    self = .he
                case .feminine:
                    self = .she
                case .neuter, .none:
                    self = .it
                }
            case .plural:
                self = .they
            case .none:
                self = .none
            }
        case .none:
            self = .none
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority == rhs.priority
    }
    
    static func != (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority != rhs.priority
    }
}
