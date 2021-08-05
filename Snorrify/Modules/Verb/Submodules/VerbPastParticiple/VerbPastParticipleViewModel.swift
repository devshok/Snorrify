import Foundation
import SFUIKit

class VerbPastParticipleViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: VerbPastParticipleTextManager
    private let model: VerbPastParticipleModel
    
    // MARK: - Property Wrappers
    
    @Published
    var noForms: Bool = false
    
    // MARK: - Initialization
    
    init(textManager: VerbPastParticipleTextManager,
         model: VerbPastParticipleModel
    ) {
        self.textManager = textManager
        self.model = model
    }
    
    // MARK: - For View
    
    var title: String {
        textManager.title.capitalized
    }
    
    var closeText: String {
        textManager.close.capitalized
    }
    
    func title(for tab: VerbPastParticipleViewTab) -> String {
        return textManager.title(for: tab).capitalized
    }
    
    var noFormsTitle: String {
        textManager.noFormsTitle
    }
    
    var noFormsDescription: String {
        textManager.noFormsDescription
    }
    
    var declensionsText: String {
        textManager.declensions.capitalized
    }
    
    func viewContracts(at tabIndex: Int) -> [SFTableSectionFormViewContract] {
        guard let tab = VerbPastParticipleViewTab(rawValue: tabIndex) else {
            debugPrint(self, #function, #line)
            return []
        }
        return [
            sectionContract(id: "1", at: tab, for: .nominative),
            sectionContract(id: "2", at: tab, for: .accusative),
            sectionContract(id: "3", at: tab, for: .dative),
            sectionContract(id: "4", at: tab, for: .genitive)
        ]
    }
    
    // MARK: - API
    
    func checkForNoForms() {
        noForms = model.noData
    }
    
    // MARK: - Helpers
    
    private func sectionContract(id: String,
                                 at tab: VerbPastParticipleViewTab,
                                 for grammarCase: GrammarCase) -> SFTableSectionFormViewContract {
        
        let header = textManager.tableTitle(for: grammarCase).capitalized
        return .init(id: id, header: header, subSections: [
            subSectionContract(id: "1", tab: tab, grammarCase: grammarCase, number: .singular),
            subSectionContract(id: "2", tab: tab, grammarCase: grammarCase, number: .plural)
        ])
    }
    
    private func subSectionContract(id: String,
                                    tab: VerbPastParticipleViewTab,
                                    grammarCase: GrammarCase,
                                    number: Number) -> SFTableSubSectionFormViewContract {
        
        let header = textManager.tableSubtitle(for: number).capitalized
        let forms: [SFCellFormViewContract] = model.forms(at: tab, grammarCase: grammarCase, number: number)
            .map {
                .init(id: $0.id,
                      title: $0.word,
                      subtitle: textManager.tableCellSubtitle(for: $0.gender))
            }
        return .init(id: id, header: header, forms: forms)
    }
    
    // MARK: - Mock / Preview
    
    static var mock: VerbPastParticipleViewModel {
        .init(textManager: .mock, model: .mock)
    }
}
