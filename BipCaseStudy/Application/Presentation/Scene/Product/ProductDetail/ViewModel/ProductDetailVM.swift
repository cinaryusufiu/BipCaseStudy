//
//  ProductDetailVM.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

final class ProductDetailVM: BaseViewModel {

    // MARK: - Published

    @Published var productDetail: ProductDetail?

    // MARK: - Dependencies

    private let productId: String
    private let useCase: ProductUseCaseProtocol

    // MARK: - Init

    init(productId: String, useCase: ProductUseCaseProtocol) {
        self.productId = productId
        self.useCase = useCase
    }
}

// MARK: - Data Loading

extension ProductDetailVM {

    func loadDetail() async {
        await performTask { [weak self] in
            guard let self else { return }
            let result = await useCase.fetchProductDetail(id: productId)
            handleResult(
                result,
                onSuccess: { self.productDetail = $0 },
                onRetry: { [weak self] in Task { await self?.loadDetail() } }
            )
        }
    }
}
