import Foundation
import SFUIKit

final class PersonalPronounViewModel {
    // MARK: - Properties
    
    private let textManager: PersonalPronounTextManager
    private let model: PersonalPronounModel
    
    // MARK: - Initialization
    
    init(textManager: PersonalPronounTextManager, model: PersonalPronounModel) {
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
    
    var contract: SFTableSectionFormViewContract {
        .init(subSections: subSections)
    }
    
    private var subSections: [SFTableSubSectionFormViewContract] {
        Number.allCases.map { number in
            if number == .none { return nil } else {
                return .init(
                    id: number.rawValue,
                    header: textManager.tableTitle(for: number),
                    forms: forms(for: number)
                )
            }
        }
        .compactMap { $0 }
    }
    
    private func forms(for number: Number) -> [SFCellFormViewContract] {
        GrammarCase.allCases.map { grammarCase in
            if grammarCase == .none { return nil } else {
                let forms = model.forms(grammarCase: grammarCase, number: number)
                switch forms.count {
                case .zero:
                    return nil
                case 1:
                    let item = forms.first!
                    return .init(
                        id: grammarCase.rawValue,
                        title: item.word,
                        subtitle: textManager.cellSubtitle(for: grammarCase).capitalized
                    )
                default:
                    var merged: SFCellFormViewContract?
                    for item in forms {
                        if merged == nil {
                            let subtitle = textManager.cellSubtitle(for: grammarCase).capitalized
                            merged = .init(id: item.id, title: item.word, subtitle: subtitle)
                        } else {
                            let subtitle = textManager.cellSubtitle(for: grammarCase).capitalized
                            let other = SFCellFormViewContract(id: item.id, title: item.word, subtitle: subtitle)
                            merged = merged?.mergeTitle(with: other)
                        }
                    }
                    return merged
                }
            }
        }
        .compactMap { $0 }
    }
    
    var noFormsContract: SFTextPlaceholderViewContract {
        .init(
            title: textManager.noFormsTitle,
            description: textManager.noFormsDescription
        )
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> PersonalPronounViewModel {
        .init(textManager: .mock, model: .mock(withData: withData))
    }
}
