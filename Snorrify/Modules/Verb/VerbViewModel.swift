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
    
    // MARK: - For View
    
    var noData: Bool {
        model.noData
    }
    
    var emptyText: String {
        textManager.empty.capitalized
    }
    
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
    
    // MARK: - Mock / Preview
    
    static var mock: VerbViewModel {
        return .init(category: .imperativeMood, textManager: .mock, model: .mock)
    }
}
