import Foundation

struct VerbSupineModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    func supineForm(for verbVoice: VerbVoice) -> SearchItemFormResponse? {
        return data?.forms?
            .filter { $0.verbVoice == verbVoice && $0.supine }
            .first
    }
    
    // MARK: - Mock / Preview
    
    static var mockWithData: Self
        = .init(data: .skiljaWithSupineForms)
    
    static var mockWithoutData: Self
        = .init(data: nil)
}
