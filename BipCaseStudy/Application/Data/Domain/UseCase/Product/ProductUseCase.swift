//
//  ProductUseCase.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

// MARK: - Protocol

protocol ProductUseCaseProtocol {
    func fetchProducts() async -> Result<[Product], NetworkError>
    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError>
}

// MARK: - Implementation

final class ProductUseCase: ProductUseCaseProtocol {

    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }

    func fetchProducts() async -> Result<[Product], NetworkError> {
        await repository.fetchProducts()
    }

    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError> {
        await repository.fetchProductDetail(id: id)
    }
}
