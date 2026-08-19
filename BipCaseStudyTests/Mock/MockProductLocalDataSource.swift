//
//  MockProductLocalDataSource.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit
@testable import BipCaseStudy

final class MockProductLocalDataSource: ProductDataSourceProtocol {

    var storedProducts: [Product] = []
    var storedDetails: [String: ProductDetail] = [:]

    var saveProductsCallCount = 0
    var saveProductDetailCallCount = 0

    func fetchProducts() async -> Result<[Product], NetworkError> {
        guard !storedProducts.isEmpty else { return .failure(NetworkError(ResponseErrorType.noData)) }
        return .success(storedProducts)
    }

    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError> {
        guard let detail = storedDetails[id] else { return .failure(NetworkError(ResponseErrorType.noData)) }
        return .success(detail)
    }

    func saveProducts(_ products: [Product]) {
        saveProductsCallCount += 1
        storedProducts = products
    }

    func saveProductDetail(_ detail: ProductDetail) {
        saveProductDetailCallCount += 1
        storedDetails[detail.productId] = detail
    }

    func clearAll() {
        storedProducts = []
        storedDetails = [:]
    }
}
