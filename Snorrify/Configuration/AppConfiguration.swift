import Foundation
import SFNetKit

final class AppConfiguration {
    
    // MARK: - Interface
    
    static var shared: Self {
        return .init()
    }
    
    lazy var netKit: NetKit = {
        .init(configuration: clientConfiguration)
    }()
    
    func buildMainModule() -> MainView {
        return MainView(viewModel: mainViewModel)
    }
}

// MARK: - Net Kit Configuration

private extension AppConfiguration {
    var clientConfiguration: ClientConfiguration {
        return ClientConfigurationImpl(
            session: session,
            attemptsPerRequest: attempsPerRequest,
            jsonDecoder: jsonDecoder
        )
    }
    
    private var attempsPerRequest: Int { 3 }
    private var jsonDecoder: JSONDecoder { .init() }
    
    private var session: URLSession {
        let s = URLSession(
            configuration: sessionConfiguration,
            delegate: nil,
            delegateQueue: sessionQueue
        )
        return s
    }
    
    private var sessionConfiguration: URLSessionConfiguration {
        let c = URLSessionConfiguration.default
        c.networkServiceType = .responsiveData
        c.timeoutIntervalForRequest = 15
        c.timeoutIntervalForResource = 15
        c.urlCache = {
            let cache = URLCache()
            cache.memoryCapacity = 3_000_000 // 3 megabytes.
            cache.diskCapacity = 40_000_000 // 40 megabytes.
            return cache
        }()
        c.waitsForConnectivity = false
        return c
    }
    
    private var sessionQueue: OperationQueue {
        let q = OperationQueue()
        q.qualityOfService = .userInitiated
        q.maxConcurrentOperationCount = 2
        q.name = "queue.netKit.Snorrify.io.github.shokuroff"
        return q
    }
}

// MARK: - Main Module Configuration

private extension AppConfiguration {
    var mainViewModel: MainViewModel {
        return MainViewModelImpl(textManager: mainTextManager, model: mainModel)
    }
    
    var mainTextManager: MainTextManager {
        return MainTextManagerImpl()
    }
    
    var mainModel: MainModel {
        return MainModelImpl()
    }
}
