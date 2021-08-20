import Foundation

enum NumeralViewTab: Int, Identifiable, Hashable, CaseIterable {
    case singular = 1
    case plural = 2
    
    var id: Int { rawValue }
}
