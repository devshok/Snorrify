import SFUIKit

final class NumeralViewModel {
    // MARK: - Properties
    
    private let textManager: NumeralTextManager
    private let model: NumeralModel
    
    // MARK: - Life Cycle
    
    init(textManager: NumeralTextManager, model: NumeralModel) {
        self.textManager = textManager
        self.model = model
    }
    
    // MARK: - Strings
    
    var title: String {
        model.numeralWord ?? .emptyFormString
    }
    
    func title(for tab: NumeralViewTab) -> String {
        return textManager.tabTitle(for: tab).capitalized
    }
    
    // MARK: - Contracts
    
    func contract(at tabIndex: Int) -> SFTableSectionFormViewContract {
        guard let tab = NumeralViewTab(rawValue: tabIndex) else {
            return .init(subSections: GrammarCase.allCases.map { grammarCase in
                .init(
                    id: grammarCase.rawValue,
                    header: textManager.tableTitle(for: grammarCase).capitalized,
                    forms: Gender.allCases.map { gender in
                        .init(
                            id: gender.rawValue,
                            title: .emptyFormString,
                            subtitle: textManager.cellSubtitle(for: gender)
                        )
                    })
            })
        }
        return .init(
            subSections: GrammarCase.allCases
                .map { grammarCase in
                    if grammarCase == .none {
                        return nil
                    } else {
                        return SFTableSubSectionFormViewContract(
                            id: grammarCase.rawValue,
                            header: textManager.tableTitle(for: grammarCase),
                            forms: forms(at: tab, for: grammarCase)
                        )
                    }
                }
                .compactMap { $0 }
        )
    }
    
    private func forms(at tab: NumeralViewTab, for grammarCase: GrammarCase) -> [SFCellFormViewContract] {
        let forms = model.forms(at: tab, for: grammarCase)
        guard !forms.isEmpty else {
            return Gender.allCases
                .sorted(by: {
                    $0.priority > $1.priority
                })
                .map { gender in
                    guard gender != .none else { return nil }
                    let subtitle = textManager.cellSubtitle(for: gender)
                    return .init(id: gender.rawValue, title: .emptyFormString, subtitle: subtitle)
                }
                .compactMap { $0 }
        }
        let groups = Dictionary(grouping: forms, by: { $0.gender })
            .sorted(by: { $0.key.priority > $1.key.priority })
        
        return groups
            .map { group in
                switch group.value.isEmpty {
                case true:
                    return nil
                case false:
                    return map(groupKey: group.key, with: group.value)
                }
            }
            .compactMap { $0 }
    }
    
    private func map(
        groupKey key: Gender,
        with value: [SearchItemFormResponse]
    ) -> SFCellFormViewContract? {
        switch value.count {
        case .zero:
            return nil
        case 1:
            let data = value.first!
            let subtitle = textManager.cellSubtitle(for: data.gender)
            return .init(id: data.id, title: data.word, subtitle: subtitle)
        default:
            var merged: SFCellFormViewContract?
            value.forEach { data in
                if merged == nil {
                    let subtitle = textManager.cellSubtitle(for: data.gender)
                    merged = .init(id: data.id, title: data.word, subtitle: subtitle)
                } else {
                    let subtitle = textManager.cellSubtitle(for: data.gender)
                    let other = SFCellFormViewContract(id: data.id, title: data.word, subtitle: subtitle)
                    merged = merged?.mergeTitle(with: other)
                }
            }
            return merged
        }
    }
    
    var noFormsContract: SFTextPlaceholderViewContract {
        .init(
            title: textManager.noFormsTitle,
            description: textManager.noFormsDescription
        )
    }
    
    // MARK: - View Logic
    
    var noData: Bool {
        model.noForms
    }
}

// MARK: - Mock / Preview

extension NumeralViewModel {
    static var mock: NumeralViewModel {
        .init(textManager: .mock, model: .mock)
    }
}

// MARK: - Extension of SFCellFormViewContract

fileprivate extension SFCellFormViewContract {
    static func empty(for gender: Gender) -> Self {
        let subtitle = NumeralTextManager().cellSubtitle(for: gender)
        return .init(title: .emptyFormString, subtitle: subtitle)
    }
}
