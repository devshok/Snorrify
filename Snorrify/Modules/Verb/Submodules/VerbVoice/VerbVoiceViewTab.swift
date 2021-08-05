import Foundation

enum VerbVoiceViewTab: Int, Hashable, Identifiable, CaseIterable {
    case indicative = 0
    case subjunctive = 1
    
    var id: Int { rawValue }
}
