import SwiftUI
import Combine
import SFUIKit

struct VerbImperativeView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @ObservedObject
    private var viewModel: VerbImperativeViewModel
    
    @State
    private var noForms = false
    
    @State
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(viewModel: VerbImperativeViewModel) {
        self.viewModel = viewModel
        self.checkForNoForms()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                if noForms {
                    VStack(alignment: .center) {
                        SFTextPlaceholderView(
                            contract: .init(
                                title: viewModel.noFormsTitle,
                                description: viewModel.noFormsDescription
                            )
                        )
                    }
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        SFTableSectionFormView(contract: viewModel.formsContract)
                    }
                    .padding(.top, 14)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(viewModel.closeText) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle(viewModel.title)
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
        viewModel.checkForNoForms()
    }
}

// MARK: - Preview

struct VermImperativeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            VerbImperativeView(viewModel: .mockWithData)
                .preferredColorScheme(scheme)
        }
    }
}
