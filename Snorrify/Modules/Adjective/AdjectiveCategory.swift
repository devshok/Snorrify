import Foundation

enum AdjectiveCategory: String, Identifiable, Hashable {
    case positiveDegree
    case comparativeDegree
    case superlativeDegree
    case none = ""
    
    var id: String { rawValue }
}
