//
//  ProductFactory.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

enum ProductFactory {

    // MARK: - ViewModel

    @MainActor
    static func makeProductListVM() -> ProductListVM {
        let useCase = makeProductUseCase()
        return ProductListVM(useCase: useCase)
    }

    @MainActor
    static func makeProductDetailVM(productId: String) -> ProductDetailVM {
        let useCase = makeProductUseCase()
        return ProductDetailVM(productId: productId, useCase: useCase)
    }

    // MARK: - UseCase

    static func makeProductUseCase() -> ProductUseCaseProtocol {
        ProductUseCase(repository: makeProductRepository())
    }

    // MARK: - Repository

    static func makeProductRepository() -> ProductRepositoryProtocol {
        guard let networkClient = ServiceLocator.shared.networkClient else {
            fatalError("NetworkClientProtocol not registered")
        }
        guard let networkMonitor = ServiceLocator.shared.networkMonitor else {
            fatalError("NetworkMonitorProtocol not registered")
        }
        guard let coreDataStack = ServiceLocator.shared.coreDataStack else {
            fatalError("CoreDataStackProtocol not registered")
        }
        let remoteDataSource = ProductRemoteDataSource(networkClient: networkClient)
        let localDataSource = ProductLocalDataSource(coreDataStack: coreDataStack)
        return ProductRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            networkMonitor: networkMonitor
        )
    }
}
