//
//  BipImageStyle.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Border Style

struct BipImageBorderStyle {
    let color: Color
    let width: CGFloat
}

// MARK: - Image Style

struct BipImageStyle {
    let width: CGFloat?
    let height: CGFloat?
    let shape: BipImageShape
    let backgroundColor: Color?
    let tintColor: Color?
    let border: BipImageBorderStyle?
    let contentMode: ContentMode

    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        shape: BipImageShape = .square,
        backgroundColor: Color? = nil,
        tintColor: Color? = nil,
        border: BipImageBorderStyle? = nil,
        contentMode: ContentMode = .fill
    ) {
        self.width = width
        self.height = height
        self.shape = shape
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.border = border
        self.contentMode = contentMode
    }
}
