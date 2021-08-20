import Foundation
import SFUIKit

final class OtherPronounViewModel {
    // MARK: - Properties
    
    private let textManager: OtherPronounTextManager
    private let model: OtherPronounModel
    
    // MARK: - Initialization
    
    init(textManager: OtherPronounTextManager, model: OtherPronounModel) {
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
    
    var noFormsTitle: String {
        textManager.noFormsTitle
    }
    
    var noFormsDescription: String {
        textManager.noFormsDescription
    }
    
    var noFormsContract: SFTextPlaceholderViewContract {
        .init(
            title: textManager.noFormsTitle,
            description: textManager.noFormsDescription
        )
    }
    
    // MARK: - Contracts
    
    var contracts: [SFTableSectionFormViewContract] {
        return GrammarCase.allCases
            .map { grammarCase in
                if grammarCase == .none { return nil } else {
                    return tableSectionContract(
                        id: grammarCase.rawValue,
                        grammarCase: grammarCase
                    )
                }
            }
            .compactMap { $0 }
    }
    
    private func tableSectionContract(id: String,
                                      grammarCase: GrammarCase) -> SFTableSectionFormViewContract {
        
        let header = textManager.grammarCase(grammarCase).capitalized
        return .init(
            id: id,
            header: header,
            subSections: Number.allCases
                .map { number in
                    if number == .none { return nil } else {
                        return subSection(
                            id: number.rawValue,
                            grammarCase: grammarCase,
                            number: number
                        )
                    }
                }
                .compactMap { $0 }
        )
    }
    
    private func subSection(id: String,
                            grammarCase: GrammarCase,
                            number: Number) -> SFTableSubSectionFormViewContract {
        
        let header = textManager.number(number)
        let forms: [SFCellFormViewContract] = model.forms(grammarCase: grammarCase,
                                                          number: number)
        .map { form in
            let subtitle = textManager.gender(form.gender)
            return .init(id: form.id, title: form.word, subtitle: subtitle)
        }
        return .init(id: id, header: header, forms: forms)
    }
    
    // MARK: - Mock / Preview
    
    static func mock(withData: Bool) -> OtherPronounViewModel {
        .init(textManager: .mock, model: .mock(withData: withData))
    }
}
