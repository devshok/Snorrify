import Foundation

extension Bundle {
    // MARK: - Errors

    enum AccessError: String, Error {
        case missingKey
        case invalidValue
        case missingBundle
    }
    
    // MARK: - Access Keys
    
    enum AccessKey: String {
        case bodyMail = "RECIPIENT_BODY_MAIL"
        case firstDomainMail = "RECIPIENT_FIRST_DOMAIN_MAIL"
        case secondDomainMail = "RECIPIENT_SECOND_DOMAIN_MAIL"
    }
    
    // MARK: - Straight Access
    
    func getValue<T>(
        for key: AccessKey
    ) throws -> T where T: LosslessStringConvertible {
        
        guard let object = object(forInfoDictionaryKey: key.rawValue) else {
            throw AccessError.missingKey
        }
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else {
                fallthrough
            }
            return value
        default:
            throw AccessError.invalidValue
        }
    }
}
