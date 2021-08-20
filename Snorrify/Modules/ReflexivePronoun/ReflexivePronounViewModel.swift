import Foundation
import SFUIKit

final class ReflexivePronounViewModel {
    // MARK: - Properties
    
    private let textManager: ReflexivePronounTextManager
    private let model: ReflexivePronounModel
    
    // MARK: - Initialization
    
    init(textManager: ReflexivePronounTextManager, model: ReflexivePronounModel) {
        self.textManager = textManager
        self.model = model
    }
    
    // MARK: - View Logic
    
    var noData: Bool {
        model.noData
    }
    
    // MARK: - Strings
    
    var title: String {
        model.word ?? .emptyFormString
    }
    
    // MARK: - Contracts
    
    var noFormsContract: SFTextPlaceholderViewContract {
        .init(
            title: textManager.noFormsTitle,
            description: textManager.noFormsDescription
        )
    }
    
    var contract: SFTableSectionFormViewContract {
        .init(subSections: [subSection])
    }
    
    private var subSection: SFTableSubSectionFormViewContract {
        .init(forms: forms)
    }
    
    private var forms: [SFCellFormViewContract] {
        GrammarCase.allCases
            .map { grammarCase in
                guard grammarCase != .none else { return nil }
                let forms = model.forms(for: grammarCase)
                switch forms.count {
                case 0:
                    let subtitle = textManager.subtitle(for: grammarCase).capitalized
                    return .init(id: grammarCase.rawValue, title: .emptyFormString, subtitle: subtitle)
                case 1:
                    let item = forms.first!
                    let subtitle = textManager.subtitle(for: grammarCase).capitalized
                    return .init(id: grammarCase.rawValue, title: item.word, subtitle: subtitle)
                default:
                    var merged: SFCellFormViewContract?
                    for item in forms {
                        let id = grammarCase.rawValue
                        let title = item.word
                        let subtitle = textManager.subtitle(for: grammarCase)
                        if merged == nil {
                            merged = .init(id: id, title: title, subtitle: subtitle)
                        } else {
                            let other = SFCellFormViewContract(id: id, title: title, subtitle: subtitle)
                            merged = merged?.mergeTitle(with: other)
                        }
                    }
                    return merged
                }
            }
            .compactMap { $0 }
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> ReflexivePronounViewModel {
        .init(textManager: .mock, model: .mock(withData: withData))
    }
}
