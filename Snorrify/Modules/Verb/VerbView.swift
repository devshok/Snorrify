import SwiftUI
import SFUIKit

struct VerbView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    var colorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
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
        case .voice:
            viewModel.buildVerbVoiceModule()
        case .imperativeMood:
            viewModel.buildVerbImperativeMoodModule()
        case .supine:
            viewModel.buildVerbSupineModule()
        case .participle(let participleType):
            switch participleType {
            case .present:
                NavigationView {
                    ZStack {
                        Color.background(when: colorScheme)
                            .ignoresSafeArea()
                        ScrollView(.vertical, showsIndicators: false) {
                            SFCellPlainFormView(text: viewModel.presentParticipleWord)
                            .padding(.top, 14)
                            .padding(.horizontal, 14)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(viewModel.closeText) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .navigationTitle(viewModel.presentParticipleTitle)
                }
            case .past:
                viewModel.buildVerbPastParticipleModule()
            }
        case .none:
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
            VerbView(viewModel: .presentParticipleMock)
                .preferredColorScheme(scheme)
        }
    }
}
