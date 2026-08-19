//
//  BipFontProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Protocol

protocol BipFontConvertible {
    func toFont() -> Font
}

// MARK: - Provider

enum BipFontProvider: BipFontConvertible {
    case largeTitle
    case title
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption
}

// MARK: - Properties

extension BipFontProvider {

    var size: CGFloat {
        switch self {
        case .largeTitle:   return 28
        case .title:        return 22
        case .headline:     return 17
        case .body:         return 17
        case .callout:      return 16
        case .subheadline:  return 15
        case .footnote:     return 13
        case .caption:      return 12
        }
    }

    var weight: Font.Weight {
        switch self {
        case .largeTitle:   return .bold
        case .title:        return .bold
        case .headline:     return .semibold
        case .body:         return .regular
        case .callout:      return .regular
        case .subheadline:  return .regular
        case .footnote:     return .regular
        case .caption:      return .regular
        }
    }
}

// MARK: - BipFontConvertible

extension BipFontProvider {

    func toFont() -> Font {
        .system(size: size, weight: weight)
    }
}
