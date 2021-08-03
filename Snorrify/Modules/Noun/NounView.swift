import SwiftUI
import SFUIKit

struct NounView: View {
    // MARK: - Property Wrappers
    
    @Environment(\.colorScheme)
    var colorScheme
    
    @State
    private var selectedPickerIndex: Int = .zero
    
    @ObservedObject
    private var viewModel: NounViewModel
    
    // MARK: - Initialization
    
    init(viewModel: NounViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.background(when: colorScheme)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 14) {
                Picker(selection: $selectedPickerIndex, label: Text("")) {
                    Text(viewModel.tabTitle(for: .no)).tag(0)
                    Text(viewModel.tabTitle(for: .yes)).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 14)
                
                ScrollView(.vertical, showsIndicators: false) {
                    if let contract = viewModel.dataContract(at: selectedPickerIndex) {
                        SFTableSectionFormView(contract: contract)
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct NounView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            NounView(viewModel: .mock)
                .preferredColorScheme(scheme)
        }
    }
}
