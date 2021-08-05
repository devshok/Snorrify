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
    
    func buildVerbSupineModel() -> VerbSupineModel {
        return .init(data: data)
    }
    
    var presentParticipleForm: SearchItemFormResponse? {
        guard let forms = data?.forms, !forms.isEmpty else {
            debugPrint(self, #function, #line)
            return nil
        }
        return forms
            .filter {
                $0.participle && $0.tense == .present
            }
            .first
    }
    
    // MARK: - Preview / Mock
    
    static var mock: VerbModel {
        .init(data: .skiljaMock)
    }
    
    static var presentParticipleMock: VerbModel {
        .init(data: .skiljaWithPresentParticipleForm)
    }
}
