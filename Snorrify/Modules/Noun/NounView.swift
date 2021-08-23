import SwiftUI
import SFUIKit
import Combine

struct NounView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    var colorScheme
    
    @State
    private var tabIndex: Int = .zero {
        didSet {
            viewModel.checkForNoForms(at: tabIndex)
        }
    }
    
    @ObservedObject
    private var viewModel: NounViewModel
    
    @State
    private var noForms: Bool = false
    
    @State
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(viewModel: NounViewModel) {
        self.viewModel = viewModel
        self.checkForNoForms()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.background(when: colorScheme)
                .ignoresSafeArea()
            
            if noForms {
                VStack {
                    SFTextPlaceholderView(
                        contract: .init(
                            title: viewModel.noFormsTitle,
                            description: viewModel.noFormsDescription
                        )
                    )
                }
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    Picker(selection: $tabIndex, label: Text("")) {
                        Text(viewModel.tabTitle(for: .no)).tag(0)
                        Text(viewModel.tabTitle(for: .yes)).tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 14)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        if let contract = viewModel.dataContract(at: tabIndex) {
                            SFTableSectionFormView(contract: contract)
                        }
                    }
                }
            }
        }
        .onAppear { listenEvents() }
    }
    
    // MARK: - Helpers
    
    private func listenEvents() {
        viewModel.$noForms
            .assign(to: \.noForms, on: self)
            .store(in: &events)
    }
    
    private func checkForNoForms() {
        viewModel.checkForNoForms(at: tabIndex)
    }
}

// MARK: - Preview

struct NounView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            NounView(viewModel: .mockWithData)
                .preferredColorScheme(scheme)
        }
    }
}
