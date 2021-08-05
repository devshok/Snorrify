import Foundation
import SFUIKit

class VerbVoiceViewModel: ObservableObject {
    // MARK: - Properties
    
    private let context: VerbVoiceContext
    private let textManager: VerbVoiceTextManager
    private let model: VerbVoiceModel
    
    @Published
    var noForms = false
    
    // MARK: - Life Cycle
    
    init(context: VerbVoiceContext,
         textManager: VerbVoiceTextManager,
         model: VerbVoiceModel
    ) {
        self.context = context
        self.textManager = textManager
        self.model = model
    }
    
    deinit {
        debugPrint(self, #function)
    }
    
    // MARK: - For View
    
    var title: String {
        textManager.title(context: context).capitalized
    }
    
    var infinitiveTitle: String {
        textManager.infinitive.capitalized
    }
    
    var infinitiveVerb: String {
        let prefix = textManager.infinitivePrefix
        let space = " "
        let verb = model.infinitiveForm(context: context)
        return prefix + space + verb
    }
    
    var closeText: String {
        textManager.close.capitalized
    }
    
    var moodsText: String {
        textManager.moods.capitalized
    }
    
    var indicativeText: String {
        textManager.indicative.capitalized
    }
    
    var subjunctiveText: String {
        textManager.subjunctive.capitalized
    }
    
    func formsContract(at index: Int) -> SFTableSectionFormViewContract {
        guard let tab = VerbVoiceViewTab(rawValue: index) else {
            return .init(header: .emptyFormString, subSections: [])
        }
        let mood: VerbMood = {
            switch tab {
            case .indicative:
                return .indicative
            case .subjunctive:
                return .subjunctive
            }
        }()
        return .init(subSections: [
            .init(id: "1", header: textManager.presentTense, forms: formContracts(tense: .present, mood: mood)),
            .init(id: "2", header: textManager.pastTense, forms: formContracts(tense: .past, mood: mood))
        ])
    }
    
    func checkNoForms(at index: Int) {
        guard let tab = VerbVoiceViewTab(rawValue: index) else {
            return
        }
        let mood: VerbMood = {
            switch tab {
            case .indicative:
                return .indicative
            case .subjunctive:
                return .subjunctive
            }
        }()
        let presentForms = formContracts(tense: .present, mood: mood)
        let pastForms = formContracts(tense: .past, mood: mood)
        self.noForms = presentForms.isEmpty && pastForms.isEmpty
    }
    
    var noFormsTitle: String {
        textManager.noFormsTitle
    }
    
    var noFormsDescription: String {
        textManager.noFormsDescription
    }
    
    // MARK: - Helpers
    
    private func formContracts(tense: Tense, mood: VerbMood) -> [SFCellFormViewContract] {
        let contracts: [SFCellFormViewContract] = model
            .forms(context: context, tense: tense, mood: mood)
            .map {
                let id = $0.id
                let title = $0.word
                let pronoun = $0.pronoun
                let subtitle = textManager.formSubtitle(for: pronoun)
                return .init(id: id, title: title, subtitle: subtitle)
            }
        return contracts
    }
    
    // MARK: - Mock / Preview
    
    static var mockWithActiveVoice: VerbVoiceViewModel {
        .init(context: .active, textManager: .mock, model: .mock)
    }
    
    static var mockWithMiddleVoice: VerbVoiceViewModel {
        .init(context: .middle, textManager: .mock, model: .mock)
    }
}
