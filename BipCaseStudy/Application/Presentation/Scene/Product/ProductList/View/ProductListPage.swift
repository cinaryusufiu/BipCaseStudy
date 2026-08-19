//
//  ProductListPage.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct ProductListPage: View {

    @EnvironmentObject var viewModel: ProductListVM

    private let columns = [
        GridItem(.flexible(), spacing: BipSpacing.medium),
        GridItem(.flexible(), spacing: BipSpacing.medium)
    ]

    // MARK: - Body

    var body: some View {
        BipPageView(viewModel: viewModel) {
            productGrid
        }
        .addNavigationBar(config: .withTitle("products_title".localized))
        .task {
            guard viewModel.products.isEmpty else { return }
            await viewModel.loadProducts()
        }
    }
}

// MARK: - Product Grid

extension ProductListPage {

    @ViewBuilder
    private var productGrid: some View {
        BipScrollView {
            LazyVGrid(columns: columns, spacing: BipSpacing.medium) {
                ForEach(viewModel.products) { product in
                    ProductCardView(product: product) {
                        navigateToDetail(productId: product.productId)
                    }
                }
            }
            .padding(BipSpacing.medium)
        }
        .refreshable { await viewModel.loadProducts() }
    }
}

// MARK: - Navigation

extension ProductListPage {

    private func navigateToDetail(productId: String) {
        let viewModel = ProductFactory.makeProductDetailVM(productId: productId)
        AppRouter.shared.push(ProductDetailPage(), viewModel: viewModel)
    }
}
