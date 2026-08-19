//
//  MockProductUseCase.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit
@testable import BipCaseStudy

final class MockProductUseCase: ProductUseCaseProtocol {

    var mockProducts: Result<[Product], NetworkError> = .success([])
    var mockProductDetail: Result<ProductDetail, NetworkError> = .failure(NetworkError(ResponseErrorType.noData))

    func fetchProducts() async -> Result<[Product], NetworkError> {
        return mockProducts
    }

    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError> {
        return mockProductDetail
    }
}
