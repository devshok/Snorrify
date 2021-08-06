import Foundation

enum AdjectiveCategory: String, Identifiable, Hashable {
    case positiveDegree
    case comparativeDegree
    case superlativeDegree
    
    var id: String { rawValue }
}
