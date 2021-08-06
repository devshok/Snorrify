import Foundation

final class VerbViewModel {
    // MARK: - Properties
    
    var category: VerbViewCategory
    private let textManager: VerbTextManager
    private let model: VerbModel
    
    // MARK: - Life Cycle
    
    init(category: VerbViewCategory, textManager: VerbTextManager, model: VerbModel) {
        self.category = category
        self.textManager = textManager
        self.model = model
    }
    
    deinit {
        debugPrint(self, #function)
    }
    
    // MARK: - For View
    
    var noData: Bool {
        model.noData
    }
    
    var emptyText: String {
        textManager.empty.capitalized
    }
    
    var presentParticipleWord: String {
        model.presentParticipleForm?.word ?? .emptyFormString
    }
    
    var presentParticipleTitle: String {
        textManager.presentParticiple.capitalized
    }
    
    var closeText: String {
        textManager.close.capitalized
    }
    
    // MARK: - Building Modules
    
    func buildVerbVoiceModule() -> VerbVoiceView {
        let textManager = VerbVoiceTextManager()
        let model = model.buildVerbVoiceModel()
        let context: VerbVoiceContext = {
            switch category {
            case .voice(.active):
                return .active
            case .voice(.middle):
                return .middle
            default:
                return .none
            }
        }()
        let viewModel = VerbVoiceViewModel(context: context,
                                           textManager: textManager,
                                           model: model)
        return .init(viewModel: viewModel)
    }
    
    func buildVerbImperativeMoodModule() -> VerbImperativeView {
        let textManager = VerbImperativeTextManager()
        let model = model.buildVerbImperativeMoodModel()
        let viewModel = VerbImperativeViewModel(textManager: textManager,
                                                model: model)
        return .init(viewModel: viewModel)
    }
    
    func buildVerbSupineModule() -> VerbSupineView {
        let textManager = VerbSupineTextManager()
        let model = model.buildVerbSupineModel()
        let viewModel = VerbSupineViewModel(textManager: textManager, model: model)
        return .init(viewModel: viewModel)
    }
    
    func buildVerbPastParticipleModule() -> VerbPastParticipleView {
        let textManager = VerbPastParticipleTextManager()
        let model = model.buildVerbPastParticipleModel()
        let viewModel = VerbPastParticipleViewModel(textManager: textManager,
                                                    model: model)
        return .init(viewModel: viewModel)
    }
    
    // MARK: - Mock / Preview
    
    static var activeVoiceMock: VerbViewModel {
        .init(category: .voice(.active),
              textManager: .mock,
              model: .mock)
    }
    
    static var middleVoiceMock: VerbViewModel {
        .init(category: .voice(.middle),
              textManager: .mock,
              model: .mock)
    }
    
    static var imperativeMoodMock: VerbViewModel {
        .init(category: .imperativeMood,
              textManager: .mock,
              model: .mock)
    }
    
    static var presentParticipleMock: VerbViewModel {
        .init(category: .participle(.present),
              textManager: .mock,
              model: .mock)
    }
    
    static var supineMock: VerbViewModel {
        .init(category: .supine,
              textManager: .mock,
              model: .mock)
    }
    
    static var pastParticipleMock: VerbViewModel {
        .init(category: .participle(.past),
              textManager: .mock,
              model: .mock)
    }
}
