//
//  BipImageShape.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

enum BipImageShape {
    case circle
    case rounded(CGFloat)
    case square

    // MARK: - Shape Providing

    @ViewBuilder
    func clipContent<V: View>(_ content: V) -> some View {
        switch self {
        case .circle:
            content.clipShape(Circle())
        case .rounded(let radius):
            content.clipShape(RoundedRectangle(cornerRadius: radius))
        case .square:
            content.clipShape(Rectangle())
        }
    }

    @ViewBuilder
    func borderOverlay(color: Color, lineWidth: CGFloat) -> some View {
        switch self {
        case .circle:
            Circle().stroke(color, lineWidth: lineWidth)
        case .rounded(let radius):
            RoundedRectangle(cornerRadius: radius).stroke(color, lineWidth: lineWidth)
        case .square:
            Rectangle().stroke(color, lineWidth: lineWidth)
        }
    }
}
