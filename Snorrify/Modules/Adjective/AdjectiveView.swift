import SwiftUI
import Combine
import SFUIKit

struct AdjectiveView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    @State
    private var tabIndex: Int = .zero
    
    @State
    private var noForms: Bool = false
    
    @State
    private var events: Set<AnyCancellable> = []
    
    @ObservedObject
    private var viewModel: AdjectiveViewModel
    
    // MARK: - Initialization
    
    init(viewModel: AdjectiveViewModel) {
        self.viewModel = viewModel
        self.checkForNoForms()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background(when: colorScheme)
                    .ignoresSafeArea()
                
                VStack {
                    
                    if noForms {
                        VStack {
                            SFTextPlaceholderView(
                                contract: .init(
                                    title: viewModel.noFormsTitle,
                                    description: viewModel.noFormsDescription
                                )
                            )
                            .padding(.top, 50)
                        }
                    } else {
                        SFCellBoldHeaderView(text: viewModel.declensionsText)
                            .padding(.horizontal, 14)
                        
                        Picker("", selection: $tabIndex) {
                            Text(viewModel.title(at: 0)).tag(0)
                            Text(viewModel.title(at: 1)).tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal, 14)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            ForEach(viewModel.viewContracts(at: tabIndex)) { contract in
                                SFTableSectionFormView(contract: contract)
                                    .padding(.top, 14)
                            }
                        }
                        .padding(.bottom, 14)
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
    
    private func checkForNoForms() {
        viewModel.checkForNoForms(at: tabIndex)
    }
    
    private func listenEvents() {
        viewModel.$noForms
            .assign(to: \.noForms, on: self)
            .store(in: &events)
    }
}

// MARK: - Preview

struct AdjectiveView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            AdjectiveView(viewModel: .mock(category: .comparativeDegree, withData: true))
                .preferredColorScheme(scheme)
        }
    }
}
