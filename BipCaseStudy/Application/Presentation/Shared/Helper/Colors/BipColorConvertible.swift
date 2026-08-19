//
//  BipColorConvertible.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Protocol

protocol BipColorConvertible {
    var colorName: String { get }
}

// MARK: - Default Implementation

extension BipColorConvertible where Self: RawRepresentable, Self.RawValue == String {

    var colorName: String { rawValue }
}

extension BipColorConvertible {

    func toColor() -> Color {
        Color(colorName)
    }
}
