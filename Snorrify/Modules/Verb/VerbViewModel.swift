import Foundation

final class VerbViewModel {
    // MARK: - Properties
    
    var category: VerbViewCategory
    private let textManager: VerbTextManager
    private let model: VerbModel
    
    // MARK: - Initialization
    
    init(category: VerbViewCategory, textManager: VerbTextManager, model: VerbModel) {
        self.category = category
        self.textManager = textManager
        self.model = model
    }
    
    // MARK: - For Subviews
    
    var noData: Bool {
        model.noData
    }
    
    var infinitiveTitleText: String {
        textManager.infinitive.capitalized
    }
    
    func infinitiveText(for tense: Tense) -> String {
        guard let form = model.infinitiveForm(for: tense)?.word, !form.isEmpty else {
            return .emptyFormString
        }
        return textManager.infinitivePrefix + " " + form
    }
    
    var emptyText: String {
        textManager.empty.capitalized
    }
    
    // MARK: - Mock / Preview
    
    static var mock: VerbViewModel {
        return .init(category: .imperativeMood, textManager: .mock, model: .mock)
    }
}
