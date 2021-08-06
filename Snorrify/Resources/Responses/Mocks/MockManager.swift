import Foundation

struct MockManager {
    static var shared: Self { .init() }
    
    func loadFromJson<D: Decodable>(_ entity: MockEntity) -> D? {
        do {
            return try _loadFromJson(entity)
            
        } catch let error as MockError {
            #if DEBUG
            print(#function, error.description)
            #endif
            return nil
        } catch let error {
            #if DEBUG
            print(#function, error.localizedDescription)
            #endif
            return nil
        }
    }
    
    private func _loadFromJson<D: Decodable>(_ entity: MockEntity) throws -> D? {
        guard let filePath = Bundle.main.path(forResource: entity.resourceName,
                                              ofType: "json") else {
            throw MockError.unablePath(entity)
        }
        let fileUrl = URL(fileURLWithPath: filePath)
        do {
            
            let data = try Data(contentsOf: fileUrl)
            do {
                let mockInstance = try JSONDecoder().decode(D.self, from: data)
                return mockInstance
            } catch let error {
                throw MockError.unableDecode(entity, error)
            }
            
        } catch {
            throw MockError.unableUrl(entity, fileUrl)
        }
    }
}
