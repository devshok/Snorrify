import Foundation

enum VerbVoiceContext: String, Hashable, Identifiable, CaseIterable {
    case active, middle, none
    
    var id: String { rawValue }
}
