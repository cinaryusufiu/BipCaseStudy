//
//  ProductRepository.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

// MARK: - Protocol

protocol ProductRepositoryProtocol {
    func fetchProducts() async -> Result<[Product], NetworkError>
    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError>
}

// MARK: - Implementation

final class ProductRepository: ProductRepositoryProtocol {

    private let remoteDataSource: ProductDataSourceProtocol
    private let localDataSource: ProductDataSourceProtocol
    private let networkMonitor: NetworkMonitorProtocol

    init(
        remoteDataSource: ProductDataSourceProtocol,
        localDataSource: ProductDataSourceProtocol,
        networkMonitor: NetworkMonitorProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.networkMonitor = networkMonitor
    }

    // MARK: - Fetch Products

    func fetchProducts() async -> Result<[Product], NetworkError> {
        guard networkMonitor.isConnected else { return await localDataSource.fetchProducts() }

        let result = await remoteDataSource.fetchProducts()

        switch result {
        case .success(let products):
            localDataSource.saveProducts(products)
            return .success(products)

        case .failure(let error):
            let localResult = await localDataSource.fetchProducts()
            if case .success = localResult { return localResult }
            return .failure(error)
        }
    }

    // MARK: - Fetch Product Detail

    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError> {
        let localResult = await localDataSource.fetchProductDetail(id: id)

        if case .success(let cached) = localResult, cached.description != nil {
            return .success(cached)
        }

        guard networkMonitor.isConnected else { return localResult }

        let remoteResult = await remoteDataSource.fetchProductDetail(id: id)

        if case .success(let detail) = remoteResult {
            localDataSource.saveProductDetail(detail)
        }

        return remoteResult
    }
}
