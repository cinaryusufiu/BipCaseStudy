//
//  ProductListVM.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

final class ProductListVM: BaseViewModel {

    // MARK: - Published

    @Published var products: [Product] = []

    // MARK: - Dependencies

    private let useCase: ProductUseCaseProtocol

    // MARK: - Init

    init(useCase: ProductUseCaseProtocol) {
        self.useCase = useCase
    }
}

// MARK: - Data Loading

extension ProductListVM {

    func loadProducts() async {
        await performTask(showLoading: products.isEmpty) { [weak self] in
            guard let self else { return }
            let result = await useCase.fetchProducts()
            handleResult(
                result,
                onSuccess: { self.products = $0 },
                emptyCheck: { $0.isEmpty },
                emptyMessage: "empty_no_products".localized,
                hasExistingData: !products.isEmpty,
                onRetry: { [weak self] in Task { await self?.loadProducts() } }
            )
        }
    }
}
