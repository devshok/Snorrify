import SwiftUI
import SFUIKit

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel = MainViewModelImpl.mock) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        TabView {
        }
        .background(Color.background(when: colorScheme))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            MainView()
                .preferredColorScheme(scheme)
        }
    }
}
