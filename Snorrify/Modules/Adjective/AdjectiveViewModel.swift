import Foundation
import SFUIKit

class AdjectiveViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: AdjectiveTextManager
    private let model: AdjectiveModel
    private let adjectiveCategory: AdjectiveCategory
    
    // MARK: - Property Wrappers
    
    @Published
    var noForms = false
    
    // MARK: - Life Cycle
    
    init(adjectiveCategory: AdjectiveCategory,
         textManager: AdjectiveTextManager,
         model: AdjectiveModel
    ) {
        self.adjectiveCategory = adjectiveCategory
        self.textManager = textManager
        self.model = model
    }
    
    deinit {
        debugPrint(self, #function, #line)
    }
    
    // MARK: - View Logic
    
    func checkForNoForms(at tabIndex: Int) {
        var foundEmptyForms: Int = .zero
        viewContracts(at: tabIndex).forEach { section in
            section.subSections.forEach { subSection in
                subSection.forms.forEach { form in
                    if form.empty { foundEmptyForms += 1 }
                }
            }
        }
        noForms = foundEmptyForms == 48
    }
    
    // MARK: - Strings
    
    var title: String {
        textManager.title(for: adjectiveCategory).capitalized
    }
    
    var declensionsText: String {
        textManager.declensions.capitalized
    }
    
    func title(at tabIndex: Int) -> String {
        guard let tab = AdjectiveViewTab(rawValue: tabIndex) else {
            return .emptyFormString
        }
        return textManager.title(for: tab).capitalized
    }
    
    var closeText: String {
        textManager.close.capitalized
    }
    
    var noFormsTitle: String {
        textManager.noFormsTitle
    }
    
    var noFormsDescription: String {
        textManager.noFormsDescription
    }
    
    // MARK: - Contracts
    
    func viewContracts(at tabIndex: Int) -> [SFTableSectionFormViewContract] {
        guard let tab = AdjectiveViewTab(rawValue: tabIndex) else {
            return []
        }
        return [
            tableSectionContract(id: "1", at: tab, grammarCase: .nominative),
            tableSectionContract(id: "2", at: tab, grammarCase: .accusative),
            tableSectionContract(id: "3", at: tab, grammarCase: .dative),
            tableSectionContract(id: "4", at: tab, grammarCase: .genitive)
        ]
    }
    
    private func tableSectionContract(id: String,
                                      at tab: AdjectiveViewTab,
                                      grammarCase: GrammarCase) -> SFTableSectionFormViewContract {
        
        let header = textManager.tableTitle(for: grammarCase).capitalized
        return .init(id: id, header: header, subSections: [
            subSection(id: "1", at: tab, grammarCase: grammarCase, number: .singular),
            subSection(id: "2", at: tab, grammarCase: grammarCase, number: .plural)
        ])
    }
    
    private func subSection(id: String,
                            at tab: AdjectiveViewTab,
                            grammarCase: GrammarCase,
                            number: Number) -> SFTableSubSectionFormViewContract {
        
        let header = textManager.tableSubtitle(for: number)
        let forms: [SFCellFormViewContract] = model.data(
            at: tab,
            grammarCase: grammarCase,
            number: number,
            degree: degree
        )
        .map { data in
            let subtitle = textManager.tableCellSubtitle(for: data.gender)
            return .init(id: data.id, title: data.word, subtitle: subtitle)
        }
        return .init(id: id, header: header, forms: forms)
    }
    
    private var degree: AdjectiveDegree {
        switch adjectiveCategory {
        case .positiveDegree:
            return .positive
        case .comparativeDegree:
            return .comparative
        case .superlativeDegree:
            return .superlative
        case .none:
            return .none
        }
    }
    
    // MARK: - Mock / Preview
    
    static func mock(category: AdjectiveCategory,
                     withData: Bool) -> AdjectiveViewModel {
        
        let model: AdjectiveModel = withData ? .mockWithData : .mockWithoutData
        return .init(adjectiveCategory: category, textManager: .mock, model: model)
    }
}
