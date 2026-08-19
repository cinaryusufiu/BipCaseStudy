//
//  ProductCardView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct ProductCardView: View {

    let product: Product
    let onTap: Completion

    // MARK: - Body

    var body: some View {
        cardContent
            .padding(BipSpacing.small)
            .cardStyle()
            .asTappable(action: onTap)
    }
}

// MARK: - Content

extension ProductCardView {

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: BipSpacing.xSmall) {
            productImage
            productName
            PriceTagView(price: product.price)
        }
    }
}

// MARK: - Components

extension ProductCardView {

    private var productImage: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .overlay(
                BipRoundedImageView(
                    url: product.image,
                    cornerRadius: BipSpacing.xSmall,
                    contentMode: .fill
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: BipSpacing.xSmall))
    }

    private var productName: some View {
        StyledText(
            product.name,
            provider: HeadlineTextProvider(lineLimit: 1)
        )
    }
}
