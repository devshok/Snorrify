import SwiftUI
import SFUIKit

struct SearchBarView: View {
    @Binding private var text: String
    @Environment(\.colorScheme) var colorScheme
    @State private var editing: Bool = false
    
    private let placeholder: String
    private let delegate: SearchBarViewDelegate?
    
    init(text: Binding<String>, placeholder: String = "", delegate: SearchBarViewDelegate? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.delegate = delegate
    }
    
    var body: some View {
        ZStack {
            Color.searchBarBackround(when: colorScheme)
                .cornerRadius(10)
            HStack(alignment: .center, spacing: 5) {
                if !editing {
                    Image(uiImage: .sfSearchBarLeftIcon ?? .init())
                        .renderingMode(.template)
                        .colorMultiply(.searchBarLeftIconColor(when: colorScheme))
                }
                TextField(placeholder, text: $text, onEditingChanged: { editing in
                    self.editing = editing
                }, onCommit: {
                    self.delegate?.searchBarViewDidPressReturnKey()
                })
            }
            .padding(.horizontal, CGFloat(editing ? 14 : 10))
        }
        .frame(maxWidth: .infinity,
               minHeight: 36,
               maxHeight: 36,
               alignment: .center)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            SearchBarView(text: $text, placeholder: "Input something..")
                .preferredColorScheme(scheme)
        }
        .previewLayout(.sizeThatFits)
    }
    
    @State private static var text: String = ""
}
