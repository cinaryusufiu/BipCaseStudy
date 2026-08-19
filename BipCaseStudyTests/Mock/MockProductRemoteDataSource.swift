//
//  MockProductRemoteDataSource.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit
@testable import BipCaseStudy

final class MockProductRemoteDataSource: ProductDataSourceProtocol {

    var mockProductsResult: Result<[Product], NetworkError> = .success([])
    var mockProductDetailResult: Result<ProductDetail, NetworkError> = .failure(NetworkError(ResponseErrorType.noData))

    var fetchProductsCallCount = 0
    var fetchProductDetailCallCount = 0

    func fetchProducts() async -> Result<[Product], NetworkError> {
        fetchProductsCallCount += 1
        return mockProductsResult
    }

    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError> {
        fetchProductDetailCallCount += 1
        return mockProductDetailResult
    }

    func saveProducts(_ products: [Product]) {}
    func saveProductDetail(_ detail: ProductDetail) {}
    func clearAll() {}
}
