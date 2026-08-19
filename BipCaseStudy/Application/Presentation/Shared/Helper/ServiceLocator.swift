//
//  ServiceLocator.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

// MARK: - Service Locator

final class ServiceLocator {

    static let shared = ServiceLocator()

    private var services: [String: Any] = [:]

    private init() {}
}

// MARK: - Registration

extension ServiceLocator {

    func register<T>(_ service: T) {
        let key = "\(T.self)"
        services[key] = service
    }

    func resolve<T>(_ type: T.Type) -> T? {
        let key = "\(type)"
        return services[key] as? T
    }

    func resolveOrCreate<T>(_ type: T.Type, creator: @escaping () -> T) -> T {
        if let service = resolve(type) {
            return service
        }
        let newService = creator()
        register(newService)
        return newService
    }
}

// MARK: - Convenience Accessors

extension ServiceLocator {

    var alertManager: BipAlertManagerProtocol? { resolve(BipAlertManagerProtocol.self) }
    var configuration: BipConfigurationProtocol? { resolve(BipConfigurationProtocol.self) }
    var networkClient: NetworkClientProtocol? { resolve(NetworkClientProtocol.self) }
    var networkMonitor: NetworkMonitorProtocol? { resolve(NetworkMonitorProtocol.self) }
    var coreDataStack: CoreDataStackProtocol? { resolve(CoreDataStackProtocol.self) }
    var imageCache: ImageCacheManagerProtocol? { resolve(ImageCacheManagerProtocol.self) }
}

// MARK: - Inject Property Wrapper

@propertyWrapper
struct Inject<T> {

    private var service: T?
    private var creator: (() -> T)?

    init() {}

    init(creator: @escaping () -> T) {
        self.creator = creator
    }

    var wrappedValue: T? {
        mutating get {
            if let service { return service }

            guard let creator else {
                let resolved = ServiceLocator.shared.resolve(T.self)
                service = resolved
                return resolved
            }

            let resolved = ServiceLocator.shared.resolveOrCreate(T.self, creator: creator)
            service = resolved
            return resolved
        }
        set {
            service = newValue
        }
    }
}
