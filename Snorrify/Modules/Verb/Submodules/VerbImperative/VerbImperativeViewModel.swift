import Foundation
import SFUIKit

class VerbImperativeViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: VerbImperativeTextManager
    private let model: VerbImperativeModel
    
    // MARK: - Property Wrappers
    
    @Published
    var noForms = false
    
    // MARK: - Initialization
    
    init(textManager: VerbImperativeTextManager, model: VerbImperativeModel) {
        self.textManager = textManager
        self.model = model
    }
    
    // MARK: - For View
    
    var title: String {
        textManager.imperativeMood.capitalized
    }
    
    var formsContract: SFTableSectionFormViewContract {
        .init(subSections: [
            .init(
                id: "1",
                header: textManager.activeVoice.capitalized,
                forms: formsContracts(for: .active)
            ),
            .init(
                id: "2",
                header: textManager.middleVoice.capitalized,
                forms: formsContracts(for: .middle)
            )
        ])
    }
    
    func checkForNoForms() {
        let noFormsForActiveVoice = formImperativeContracts(for: .active).isEmpty
        let noFormsForMiddleVoice = formImperativeContracts(for: .middle).isEmpty
        noForms = noFormsForActiveVoice && noFormsForMiddleVoice
    }
    
    var noFormsTitle: String {
        textManager.noFormsTitle
    }
    
    var noFormsDescription: String {
        textManager.noFormsDescription
    }
    
    var closeText: String {
        textManager.close.capitalized
    }
    
    // MARK: - Helpers
    
    private func formsContracts(for voice: VerbVoice) -> [SFCellFormViewContract] {
        let rootContract = formRootContract(for: voice)
        let formsContracts = formImperativeContracts(for: voice)
        return [rootContract] + formsContracts
    }
    
    private func formRootContract(for voice: VerbVoice) -> SFCellFormViewContract {
        let result: SFCellFormViewContract = model.formWithRoot(verbVoice: voice)
            
            .map { (item: SearchItemFormResponse?) -> SFCellFormViewContract in
                let id = item?.id ?? ""
                let title = item?.word ?? .emptyFormString
                let subtitle = textManager.root
                return .init(id: id, title: title, subtitle: subtitle)
            } ?? .init(id: "0", title: .emptyFormString, subtitle: textManager.root)
        
        return result
    }
    
    private func formImperativeContracts(for voice: VerbVoice) -> [SFCellFormViewContract] {
        let result: [SFCellFormViewContract] = model.imperativeForms(voice: voice)
            .map {
                let id = $0.id
                let title = $0.word
                let pronoun = $0.verbImperativePronoun
                let subtitle = textManager.tip(for: pronoun)
                return .init(id: id, title: title, subtitle: subtitle)
            }
        return result
    }
    
    // MARK: - Mock / Preview
    
    static var mockWithData: VerbImperativeViewModel =
        .init(textManager: .mock, model: .mock)
    
    static var mockWithoutData: VerbImperativeViewModel =
        .init(textManager: .mock, model: .init(data: nil))
}

// MARK: - Extension of SearchItemFormResponse

fileprivate extension SearchItemFormResponse {
    var verbImperativePronoun: Pronoun {
        return .you(number)
    }
}
