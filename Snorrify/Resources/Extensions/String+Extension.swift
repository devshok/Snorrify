import Foundation

extension String {
    var localized: Self {
        Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
    func localized(args arguments: CVarArg...) -> Self {
        return Self(format: self.localized, arguments: arguments)
    }
    
    static var supineTag: String {
        // sagnbót:
        "SAGNB"
    }
    
    static var participleTag: String {
        // lýsingarháttur:
        "LH"
    }
    
    static var rootTag: String {
        // stýfður:
        "ST"
    }
    
    static var questionTag: String {
        // spurnamynd:
        "SP"
    }
    
    static var impersonalTag: String {
        // ópersonulegur:
        "OP"
    }
    
    static var infinitiveTag: String {
        // nafnháttur:
        "NH"
    }
}
