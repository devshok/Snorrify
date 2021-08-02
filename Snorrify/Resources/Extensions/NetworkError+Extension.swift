import SFNetKit

extension NetworkError {
    private typealias Key = LocalizationKey.NetworkError
    
    var localized: String {
        switch self {
        case .unknown:
            return Key.unknown.localizedString
        case .cancelledRequest:
            return Key.cancelledRequest.localizedString
        case .badRequest:
            return Key.badRequest.localizedString
        case .badURL:
            return Key.badRequest.localizedString
        case .timedOut:
            return Key.timedOut.localizedString
        case .serverUnavailable:
            return Key.serverUnavailable.localizedString
        case .noInternet:
            return Key.noInternet.localizedString
        case .badInternet:
            return Key.badInternet.localizedString
        case .notFound:
            return Key.notFound.localizedString
        case .badResponse:
            return Key.badResponse.localizedString
        case .other:
            return Key.unknown.localizedString
        case .noSearchResults:
            return Key.notFound.localizedString
        }
    }
}
