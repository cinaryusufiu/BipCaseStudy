//
//  BipNavigationBarConfig.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Bar Button Model

struct BipBarButtonModel {
    let icon: String
    let tintColor: Color
    let action: Completion

    init(
        icon: String,
        tintColor: Color = TextColorProvider.primary.toColor(),
        action: @escaping Completion
    ) {
        self.icon = icon
        self.tintColor = tintColor
        self.action = action
    }
}

// MARK: - Navigation Bar Config

struct BipNavigationBarConfig {
    let title: String
    let titleColor: Color
    let backgroundColor: Color
    let leftButton: BipBarButtonModel?
    let rightButton: BipBarButtonModel?

    init(
        title: String = "",
        titleColor: Color = TextColorProvider.primary.toColor(),
        backgroundColor: Color = BackgroundColorProvider.secondary.toColor(),
        leftButton: BipBarButtonModel? = nil,
        rightButton: BipBarButtonModel? = nil
    ) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.leftButton = leftButton
        self.rightButton = rightButton
    }
}

// MARK: - Presets

extension BipNavigationBarConfig {

    static func withBackButton(
        title: String = "",
        onBack: @escaping Completion
    ) -> BipNavigationBarConfig {
        BipNavigationBarConfig(
            title: title,
            leftButton: BipBarButtonModel(icon: BipIcons.chevronLeft, action: onBack)
        )
    }

    static func withTitle(_ title: String) -> BipNavigationBarConfig {
        BipNavigationBarConfig(title: title)
    }
}
