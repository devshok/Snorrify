import SwiftUI
import SFUIKit

struct VerbView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    var colorScheme
    
    // MARK: - Properties
    
    private let viewModel: VerbViewModel
    
    // MARK: - Initialization
    
    init(viewModel: VerbViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        if viewModel.noData {
            SFTextPlaceholderView(
                contract: .init(title: viewModel.emptyText, description: "")
            )
        } else {
            CurrentView()
        }
    }
}

// MARK: - Current View

private extension VerbView {
    @ViewBuilder
    func CurrentView() -> some View {
        switch viewModel.category {
        case .voice(let voiceType):
            SFTextPlaceholderView(
                contract: .init(title: viewModel.emptyText, description: "")
            )
        case .imperativeMood:
            SFTextPlaceholderView(
                contract: .init(title: viewModel.emptyText, description: "")
            )
        case .supine:
            SFTextPlaceholderView(
                contract: .init(title: viewModel.emptyText, description: "")
            )
        case .participle(let participleType):
            SFTextPlaceholderView(
                contract: .init(title: viewModel.emptyText, description: "")
            )
        }
    }
}

// MARK: - Preview

struct VerbView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            VerbView(viewModel: .mock)
                .preferredColorScheme(scheme)
        }
    }
}
