import Foundation

extension String {
    var localized: Self {
        Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
    func localized(args arguments: CVarArg...) -> Self {
        return Self(format: self.localized, arguments: arguments)
    }
}
