//
//  PriceTagView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct PriceTagView: View {

    let price: Int
    let formatter: PriceFormatterStrategy

    init(price: Int, formatter: PriceFormatterStrategy = DollarPriceFormatter()) {
        self.price = price
        self.formatter = formatter
    }

    var body: some View {
        StyledText(formatter.format(cents: price), provider: PriceTextProvider())
            .padding(.horizontal, 10)
            .padding(.vertical, BipSpacing.xxSmall)
            .background(
                UtilityColorProvider.priceTag.toColor().opacity(0.12)
            )
            .cornerRadius(BipSpacing.xSmall)
    }
}
