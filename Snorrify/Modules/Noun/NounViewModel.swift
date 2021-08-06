import Foundation
import SFUIKit

final class NounViewModel: ObservableObject {
    // MARK: - Properties
    
    private let data: SearchItemResponse?
    private let textManager: NounTextManager
    
    // MARK: - Property Wrappers
    
    @Published
    var noForms = false
    
    // MARK: - Life Cycle
    
    init(data: SearchItemResponse?, textManager: NounTextManager = .mock) {
        self.data = data
        self.textManager = textManager
    }
    
    deinit {
        debugPrint(self, #function)
    }
    
    // MARK: - Strings
    
    var noFormsTitle: String {
        textManager.noFormsTitle
    }
    
    var noFormsDescription: String {
        textManager.noFormsDescription
    }
    
    func tabTitle(for article: DefiniteArticle) -> String {
        switch article {
        case .yes:
            return textManager.definiteArticle.capitalized
        case .no:
            return textManager.indefiniteArticle.capitalized
        }
    }
    
    // MARK: - Contracts
    
    func dataContract(at index: Int) -> SFTableSectionFormViewContract? {
        guard let tab = NounViewTab(rawValue: index), let data = data else {
            debugPrint(self, #function, #line)
            return nil
        }
        let sectionTitleForSingularForms = textManager.tableSectionTitle(for: .singular)
        let sectiontitleForPluralForms = textManager.tableSectionTitle(for: .plural)
        switch tab {
        case .indefinite:
            let singularForms = data.nounContracts(with: .no, and: .singular)
            let pluralForms = data.nounContracts(with: .no, and: .plural)
            return .init(subSections: [
                .init(id: "1", header: sectionTitleForSingularForms, forms: singularForms),
                .init(id: "2", header: sectiontitleForPluralForms, forms: pluralForms)
            ])
        case .definite:
            let singularForms = data.nounContracts(with: .yes, and: .singular)
            let pluralForms = data.nounContracts(with: .yes, and: .plural)
            return .init(subSections: [
                .init(id: "1", header: sectionTitleForSingularForms, forms: singularForms),
                .init(id: "2", header: sectiontitleForPluralForms, forms: pluralForms)
            ])
        }
    }
    
    private func sectionTitle(for number: Number) -> String {
        switch number {
        case .singular, .plural:
            return textManager.tableSectionTitle(for: number)
        case .none:
            return ""
        }
    }
    
    // MARK: - View Logic
    
    func checkForNoForms(at tabIndex: Int) {
        guard let tab = NounViewTab(rawValue: tabIndex) else {
            debugPrint(self, #function, #line)
            return
        }
        guard let data = self.data else {
            debugPrint(self, #function, #line)
            self.noForms = true
            return
        }
        guard let forms = data.forms, !forms.isEmpty else {
            debugPrint(self, #function, #line)
            self.noForms = true
            return
        }
        let article: DefiniteArticle = {
            switch tab {
            case .indefinite:
                return .no
            case .definite:
                return .yes
            }
        }()
        noForms = forms.filter { $0.article == article }.isEmpty
    }
    
    // MARK: - Mock / Preview
    
    static var mockWithData: NounViewModel {
        return .init(data: .bananiMock, textManager: .mock)
    }
    
    static var mockWithoutData: NounViewModel {
        return .init(data: nil, textManager: .mock)
    }
}

// MARK: - Search Item Response Extension

fileprivate extension SearchItemResponse {
    func nounContracts(with article: DefiniteArticle, and number: Number) -> [SFCellFormViewContract] {
        guard let forms = forms, !forms.isEmpty else {
            debugPrint(self, #function, #line)
            return []
        }
        return forms
            .filter { $0.article == article && $0.number == number }
            .sorted(by: { $0.grammarCase.priority > $1.grammarCase.priority })
            .map { $0.toCellFormViewContract() }
    }
}

// MARK: - Search Item Form Response Extension

fileprivate extension SearchItemFormResponse {
    func toCellFormViewContract() -> SFCellFormViewContract {
        let subtitle = NounTextManager().cellSubtitle(for: self.grammarCase).capitalized
        return .init(id: self.id, title: self.word, subtitle: subtitle)
    }
}
