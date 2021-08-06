import Foundation

enum MockError: Error, CustomStringConvertible {
    case unablePath(MockEntity)
    case unableUrl(MockEntity, URL)
    case unableDecode(MockEntity, Error)
    case system(MockEntity, Error)
    
    var description: String {
        switch self {
        case .unablePath(let entity):
            return "unable path for the next entity: \(entity.id)"
        case let .unableUrl(entity, url):
            return "unable to get entity \(entity.id) in the next url: \(url.absoluteString)"
        case let .unableDecode(entity, systemError):
            let id = entity.id
            let error = systemError.localizedDescription
            return "unable to get entity \(id) because unable to decode with the error: \(error)"
        case let .system(entity, systemError):
            let id = entity.id
            let error = systemError.localizedDescription
            return "unable to get entity \(id) because of some system error: \(error)"
        }
    }
}
