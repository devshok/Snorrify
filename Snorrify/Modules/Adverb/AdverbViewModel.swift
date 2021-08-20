import Foundation
import SFUIKit

final class AdverbViewModel {
    // MARK: - Properties
    
    private let textManager: AdverbTextManager
    private let model: AdverbModel
    
    // MARK: - Initialization
    
    init(textManager: AdverbTextManager, model: AdverbModel) {
        self.textManager = textManager
        self.model = model
    }
    
    // MARK: - View Logic
    
    var noData: Bool {
        model.noData
    }
    
    // MARK: - Strings
    
    var title: String {
        model.word ?? .emptyFormString
    }
    
    // MARK: - Contracts
    
    var contract: SFTableSectionFormViewContract {
        .init(subSections: subSections)
    }
    
    var noFormsContract: SFTextPlaceholderViewContract {
        .init(
            title: textManager.noFormsTitle,
            description: textManager.noFormsDescription
        )
    }
    
    private var subSections: [SFTableSubSectionFormViewContract] {
        [
            .init(forms: AdjectiveDegree.allCases
                    .map { degree in
                        if degree == .none { return nil }
                        let forms = model.forms(for: degree)
                        switch forms.count {
                        case 0:
                            let subtitle = textManager.cellSubtitle(for: degree).capitalized
                            return .init(id: degree.rawValue, title: .emptyFormString, subtitle: subtitle)
                        case 1:
                            let item = forms.first!
                            let subtitle = textManager.cellSubtitle(for: degree).capitalized
                            return .init(id: degree.rawValue, title: item.word, subtitle: subtitle)
                        default:
                            var merged: SFCellFormViewContract?
                            let subtitle = textManager.cellSubtitle(for: degree).capitalized
                            let id = degree.rawValue
                            for item in forms {
                                if merged == nil {
                                    merged = .init(id: id, title: item.word, subtitle: subtitle)
                                } else {
                                    let other = SFCellFormViewContract(id: id, title: item.word, subtitle: subtitle)
                                    merged = merged?.mergeTitle(with: other)
                                }
                            }
                            return merged
                        }
                    }
                    .compactMap { $0 }
            )
        ]
    }
}

// MARK: - Mock / Preview

extension AdverbViewModel {
    static func mock(withData: Bool) -> AdverbViewModel {
        .init(textManager: .mock, model: .mock(withData: withData))
    }
}
