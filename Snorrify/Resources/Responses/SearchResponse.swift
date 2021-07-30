import Foundation

struct SearchResponse/*: Codable, Hashable, Identifiable*/ {
    enum CodingKeys: String, CodingKey {
        case word = "ord" // String
        case id = "guid" // String
        case wordClass = "ofl" // WordClass
    }
    
    //let id: String
}
