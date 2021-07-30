import UIKit

extension UIApplication {
    func hideKeyboard() {
        let action = #selector(UIResponder.resignFirstResponder)
        sendAction(action, to: nil, from: nil, for: nil)
    }
}
