import Foundation

enum ResultsViewState: String, Identifiable, Hashable, CaseIterable {
    case options
    case loading
    case error
    case empty
    case noun
    case adjective
    case verb
    case numeral
    case personalPronoun
    case reflexivePronoun
    case adverb
    case ordinal
    case otherPronoun
    case noForms
    case none
    
    var id: String { rawValue }
    
    var favorable: Bool {
        Set<Self>.init(
            [
                .noun,
                .adjective,
                .verb,
                .numeral,
                .personalPronoun,
                .reflexivePronoun,
                .adverb,
                .ordinal,
                .otherPronoun
            ]
        ).contains(self)
    }
}
