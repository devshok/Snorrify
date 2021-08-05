import Combine
import SFUIKit

class VerbSupineViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: VerbSupineTextManager
    private let model: VerbSupineModel
    
    // MARK: - Property Wrappers
    
    @Published
    var noForms = false
    
    // MARK: - Life Cycle
    
    init(textManager: VerbSupineTextManager,
         model: VerbSupineModel
    ) {
        self.textManager = textManager
        self.model = model
    }
    
    deinit {
        debugPrint(self, #function)
    }
    
    // MARK: - For View
    
    var title: String {
        textManager.title.capitalized
    }
    
    var viewContract: SFTableSectionFormViewContract {
        .init(subSections: [.init(forms: formsContracts)])
    }
    
    func checkForNoForms() {
        let activeVoiceSupineContractEmpty = formContract(for: .active).empty
        let middleVoiceSupineContractEmpty = formContract(for: .middle).empty
        noForms = activeVoiceSupineContractEmpty && middleVoiceSupineContractEmpty
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
    
    private var formsContracts: [SFCellFormViewContract] {
        let activeVoiceSupineContract = formContract(for: .active)
        let middleVoiceSupineContract = formContract(for: .middle)
        return [activeVoiceSupineContract, middleVoiceSupineContract]
    }
    
    private func formContract(for verbVoice: VerbVoice) -> SFCellFormViewContract {
        let defaultEmptySupineContract = SFCellFormViewContract(
            title: .emptyFormString,
            subtitle: textManager.subtitle(for: verbVoice).capitalized
        )
        return model.supineForm(for: verbVoice)
            .map {
                let id = $0.id
                let title = $0.word
                let subtitle = textManager.subtitle(for: verbVoice).capitalized
                return .init(id: id, title: title, subtitle: subtitle)
            } ?? defaultEmptySupineContract
    }
    
    // MARK: - Mock / Preview
    
    static var mockWithoutData: VerbSupineViewModel
        = .init(textManager: .mock, model: .mockWithoutData)
    
    static var mockWithData: VerbSupineViewModel
        = .init(textManager: .mock, model: .mockWithData)
}
