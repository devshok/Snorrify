import SwiftUI
import SFUIKit
import Combine

struct VerbVoiceView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    var colorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @State
    private var currentTabIndex: Int = .zero {
        didSet {
            checkForNoForms()
        }
    }
    
    @ObservedObject
    private var viewModel: VerbVoiceViewModel
    
    @State
    private var noForms = false
    
    @State
    private var events: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init(viewModel: VerbVoiceViewModel) {
        self.viewModel = viewModel
        self.checkForNoForms()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    
                    SFCellBoldHeaderView(text: viewModel.infinitiveTitle)
                    
                    SFCellFormView(contract: .init(title: viewModel.infinitiveVerb, subtitle: ""))
                    
                    SFCellBoldHeaderView(text: viewModel.moodsText)
                    
                    Picker(selection: $currentTabIndex, label: Text("")) {
                        Text(viewModel.indicativeText).tag(0)
                        Text(viewModel.subjunctiveText).tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if noForms {
                        SFTextPlaceholderView(
                            contract: .init(
                                title: viewModel.noFormsTitle,
                                description: viewModel.noFormsDescription
                            )
                        )
                        .padding(.top, 28)
                    } else {
                        SFTableSectionFormView(contract: viewModel.formsContract(at: currentTabIndex))
                            .padding(.horizontal, -14)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 7)
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
    
    private func checkForNoForms() {
        viewModel.checkNoForms(at: currentTabIndex)
    }
    
    private func listenEvents() {
        viewModel.$noForms
            .assign(to: \.noForms, on: self)
            .store(in: &events)
    }
}

// MARK: - Preview

struct VerbVoiceView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            VerbVoiceView(viewModel: .mockWithMiddleVoice)
                .preferredColorScheme(scheme)
        }
    }
}
