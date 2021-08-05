import Foundation

final class VerbModel {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    
    // MARK: - Initialization
    
    init(data: SearchItemResponse?) {
        self.data = data
    }
    
    // MARK: - Getters
    
    var noData: Bool {
        return data?.forms?.isEmpty ?? true
    }
    
    // MARK: - API
    
    func buildVerbVoiceModel() -> VerbVoiceModel {
        return .init(data: data)
    }
    
    func buildVerbImperativeMoodModel() -> VerbImperativeModel {
        return .init(data: data)
    }
    
    // MARK: - Preview / Mock
    
    static var mock: VerbModel {
        .init(data: .skiljaMock)
    }
}
