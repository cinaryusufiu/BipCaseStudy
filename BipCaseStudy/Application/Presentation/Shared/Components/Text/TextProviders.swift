//
//  TextProviders.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Large Title

struct LargeTitleTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.largeTitle.toFont()
    var color: Color
    var alignment: TextAlignment = .leading
    var lineLimit: Int? = nil

    init(color: Color = TextColorProvider.primary.toColor()) {
        self.color = color
    }
}

// MARK: - Title

struct TitleTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.title.toFont()
    var color: Color
    var alignment: TextAlignment = .leading
    var lineLimit: Int? = nil

    init(color: Color = TextColorProvider.primary.toColor()) {
        self.color = color
    }
}

// MARK: - Headline

struct HeadlineTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.headline.toFont()
    var color: Color
    var alignment: TextAlignment
    var lineLimit: Int?

    init(
        color: Color = TextColorProvider.primary.toColor(),
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
}

// MARK: - Body

struct BodyTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.body.toFont()
    var color: Color
    var alignment: TextAlignment = .leading
    var lineLimit: Int? = nil

    init(color: Color = TextColorProvider.primary.toColor()) {
        self.color = color
    }
}

// MARK: - Secondary

struct SecondaryTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.subheadline.toFont()
    var color: Color
    var alignment: TextAlignment
    var lineLimit: Int? = nil

    init(
        color: Color = TextColorProvider.secondary.toColor(),
        alignment: TextAlignment = .leading
    ) {
        self.color = color
        self.alignment = alignment
    }
}

// MARK: - Caption

struct CaptionTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.caption.toFont()
    var color: Color
    var alignment: TextAlignment = .leading
    var lineLimit: Int? = nil

    init(color: Color = TextColorProvider.secondary.toColor()) {
        self.color = color
    }
}

// MARK: - Price

struct PriceTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.headline.toFont()
    var color: Color = UtilityColorProvider.priceTag.toColor()
    var alignment: TextAlignment = .leading
    var lineLimit: Int? = 1
}

// MARK: - Button

struct ButtonTextProvider: TextStyleProvider {
    var font: Font = BipFontProvider.headline.toFont()
    var color: Color
    var alignment: TextAlignment = .center
    var lineLimit: Int? = 1

    init(color: Color = TextColorProvider.white.toColor()) {
        self.color = color
    }
}
