//
//  BipPrimaryButtonProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipPrimaryButtonProvider: ButtonProviding {

    private let iconStyle = BipImageStyle(width: 16, height: 16, contentMode: .fit)

    func createButton(config: BipButtonConfig) -> some View {
        Button(action: {
            guard !config.isDisabled else { return }
            config.onTap()
        }) {
            createContent(config: config)
                .frame(maxWidth: .infinity)
                .frame(height: config.buttonHeight)
                .background(
                    config.isDisabled
                        ? TextColorProvider.secondary.toColor().opacity(0.3)
                        : StatusColorProvider.accent.toColor()
                )
                .foregroundColor(TextColorProvider.white.toColor())
                .cornerRadius(config.cornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(config.isDisabled)
    }
}

// MARK: - Private

extension BipPrimaryButtonProvider {

    @ViewBuilder
    private func createContent(config: BipButtonConfig) -> some View {
        HStack(spacing: 8) {
            if config.iconPosition == .left, let iconName = config.iconName {
                BipCustomImageView(systemName: iconName, style: iconStyle)
            }

            StyledText(config.label, provider: ButtonTextProvider())

            if config.iconPosition == .right, let iconName = config.iconName {
                BipCustomImageView(systemName: iconName, style: iconStyle)
            }
        }
    }
}
