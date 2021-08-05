import SwiftUI
import Combine
import SFUIKit

struct VerbPastParticipleView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @State
    private var noForms = false
    
    @State
    private var events: Set<AnyCancellable> = []
    
    @ObservedObject
    private var viewModel: VerbPastParticipleViewModel
    
    @State
    private var tabIndex: Int = .zero
    
    // MARK: - Initialization
    
    init(viewModel: VerbPastParticipleViewModel) {
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
                    VStack {
                        SFTextPlaceholderView(
                            contract: .init(
                                title: viewModel.noFormsTitle,
                                description: viewModel.noFormsDescription
                            )
                        )
                    }
                    .edgesIgnoringSafeArea(.top)
                } else {
                    VStack {
                        SFCellBoldHeaderView(text: viewModel.declensionsText)
                            .padding(.horizontal, 14)
                        
                        Picker("", selection: $tabIndex) {
                            Text(viewModel.title(for: .strong)).tag(0)
                            Text(viewModel.title(for: .weak)).tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 14)
                        .padding(.bottom, 14)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(viewModel.viewContracts(at: tabIndex)) { contract in
                                SFTableSectionFormView(contract: contract)
                                    .padding(.bottom, 14)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(viewModel.closeText, action: {
                        presentationMode.wrappedValue.dismiss()
                    })
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

struct VerbPastParticipleView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            VerbPastParticipleView(viewModel: .mock)
                .preferredColorScheme(scheme)
        }
    }
}
