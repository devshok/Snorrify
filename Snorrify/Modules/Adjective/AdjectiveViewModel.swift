import Foundation

class AdjectiveViewModel: ObservableObject {
    // MARK: - Properties
    
    private let textManager: AdjectiveTextManager
    private let model: AdjectiveModel
    
    init(textManager: AdjectiveTextManager, model: AdjectiveModel) {
        self.textManager = textManager
        self.model = model
    }
    
    // MARK: - Mock Preview
}
