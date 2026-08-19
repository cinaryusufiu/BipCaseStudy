//
//  View+Extension.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Tappable

extension View {

    func asTappable(action: @escaping Completion) -> some View {
        Button(action: action) { self }
            .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Card Style

extension View {

    func cardStyle(cornerRadius: CGFloat = BipSpacing.small) -> some View {
        self
            .background(BackgroundColorProvider.card.toColor())
            .cornerRadius(cornerRadius)
            .shadow(
                color: UtilityColorProvider.shadow.toColor(),
                radius: 4,
                x: 0,
                y: 2
            )
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}

// MARK: - Conditional Modifiers

extension View {

    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, apply: (Self, T) -> Content) -> some View {
        if let value = value {
            apply(self, value)
        } else {
            self
        }
    }
}

// MARK: - Image Style Modifiers

extension View {

    func applyClipping(using shape: BipImageShape) -> some View {
        shape.clipContent(self)
    }

    @ViewBuilder
    func applyBorder(from style: BipImageStyle) -> some View {
        if let border = style.border {
            self.overlay(style.shape.borderOverlay(color: border.color, lineWidth: border.width))
        } else {
            self
        }
    }

    @ViewBuilder
    func applyOptionalFrame(style: BipImageStyle) -> some View {
        self
            .ifLet(style.width) { view, w in view.frame(width: w) }
            .ifLet(style.height) { view, h in view.frame(height: h) }
    }

    @ViewBuilder
    func applyTint(_ color: Color?) -> some View {
        if let color = color {
            self.foregroundColor(color)
        } else {
            self
        }
    }
}
