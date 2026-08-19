//
//  ProductDetailPage.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct ProductDetailPage: View {

    @EnvironmentObject var viewModel: ProductDetailVM

    // MARK: - Body

    var body: some View {
        BipPageView(viewModel: viewModel) {
            scrollContent
        }
        .addNavigationBar(
            config: .withBackButton(
                title: "product_detail_title".localized,
                onBack: { navigateBack() }
            )
        )
        .task { await viewModel.loadDetail() }
    }
}

// MARK: - Navigation

extension ProductDetailPage {

    private func navigateBack() {
        AppRouter.shared.pop()
    }
}

// MARK: - Content

extension ProductDetailPage {

    private var scrollContent: some View {
        BipScrollView {
            VStack(alignment: .leading, spacing: BipSpacing.medium) {
                if let detail = viewModel.productDetail {
                    heroImage(detail)
                    productInfo(detail)
                }
            }
            .padding(BipSpacing.medium)
        }
    }
}

// MARK: - Hero Image

extension ProductDetailPage {

    @ViewBuilder
    private func heroImage(_ detail: ProductDetail) -> some View {
        BipRoundedImageView(
            url: detail.image,
            height: 300,
            cornerRadius: BipSpacing.medium,
            contentMode: .fit
        )
        .frame(maxWidth: .infinity)
        .clipped()
    }
}

// MARK: - Product Info

extension ProductDetailPage {

    @ViewBuilder
    private func productInfo(_ detail: ProductDetail) -> some View {
        VStack(alignment: .leading, spacing: BipSpacing.small) {
            StyledText(detail.name, provider: LargeTitleTextProvider())

            PriceTagView(price: detail.price)

            Divider().padding(.vertical, BipSpacing.xxSmall)

            descriptionSection(detail)
        }
    }

    @ViewBuilder
    private func descriptionSection(_ detail: ProductDetail) -> some View {
        if let description = detail.description, description.isNotEmpty {
            StyledText("description_title".localized, provider: HeadlineTextProvider())

            StyledText(description, provider: SecondaryTextProvider())
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
