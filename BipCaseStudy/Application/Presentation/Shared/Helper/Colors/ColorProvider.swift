//
//  ColorProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Text

enum TextColorProvider: String, BipColorConvertible {
    case primary = "TextPrimary"
    case secondary = "TextSecondary"
    case white = "TextWhite"
}

// MARK: - Background

enum BackgroundColorProvider: String, BipColorConvertible {
    case primary = "BackgroundPrimary"
    case secondary = "BackgroundSecondary"
    case card = "BackgroundCard"
}

// MARK: - Status

enum StatusColorProvider: String, BipColorConvertible {
    case accent = "Accent"
    case error = "Error"
    case success = "Success"
    case warning = "Warning"
}

// MARK: - Utility

enum UtilityColorProvider: String, BipColorConvertible {
    case border = "Border"
    case shadow = "Shadow"
    case priceTag = "PriceTag"
}
