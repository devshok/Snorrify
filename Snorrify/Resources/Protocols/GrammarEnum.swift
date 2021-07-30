import Foundation

protocol GrammarEnum: Codable, Identifiable, Hashable, CaseIterable {
    init(inflectionalTag tag: String)
}

extension GrammarEnum where Self: RawRepresentable {
    var id: String { rawValue as? String ?? "" }
}
