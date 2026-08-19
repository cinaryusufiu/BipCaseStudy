//
//  ProductRemoteDataSource.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

final class ProductRemoteDataSource: ProductDataSourceProtocol {

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
}

// MARK: - API Paths

extension ProductRemoteDataSource {

    private enum APIPath {
        static let productList = "cart/list"

        static func productDetail(id: String) -> String {
            "cart/\(id)/detail"
        }
    }
}

// MARK: - Fetch

extension ProductRemoteDataSource {

    func fetchProducts() async -> Result<[Product], NetworkError> {
        let endpoint = Endpoint<ProductListResponse>(
            path: APIPath.productList,
            context: .api
        )
        let result = await networkClient.execute(endpoint)

        switch result {
        case .success(let response):
            return .success(response.products)
        case .failure(let error):
            return .failure(error)
        }
    }

    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError> {
        let endpoint = Endpoint<ProductDetail>(
            path: APIPath.productDetail(id: id),
            context: .api
        )
        return await networkClient.execute(endpoint)
    }
}

// MARK: - Save (No-op for remote)

extension ProductRemoteDataSource {

    func saveProducts(_ products: [Product]) {}
    func saveProductDetail(_ detail: ProductDetail) {}
    func clearAll() {}
}
