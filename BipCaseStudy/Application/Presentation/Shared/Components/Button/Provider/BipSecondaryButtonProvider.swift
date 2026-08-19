//
//  BipSecondaryButtonProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipSecondaryButtonProvider: ButtonProviding {

    private let iconStyle = BipImageStyle(width: 16, height: 16, contentMode: .fit)

    func createButton(config: BipButtonConfig) -> some View {
        Button(action: config.onTap) {
            createContent(config: config)
                .frame(maxWidth: .infinity)
                .frame(height: config.buttonHeight)
                .background(
                    config.isDisabled
                        ? TextColorProvider.secondary.toColor().opacity(0.3)
                        : TextColorProvider.primary.toColor()
                )
                .foregroundColor(TextColorProvider.white.toColor())
                .cornerRadius(config.cornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(config.isDisabled)
    }
}

// MARK: - Private

extension BipSecondaryButtonProvider {

    @ViewBuilder
    private func createContent(config: BipButtonConfig) -> some View {
        HStack(spacing: 8) {
            if config.iconPosition == .left, let iconName = config.iconName {
                BipCustomImageView(systemName: iconName, style: iconStyle)
            }

            StyledText(config.label, provider: ButtonTextProvider(color: TextColorProvider.white.toColor()))

            if config.iconPosition == .right, let iconName = config.iconName {
                BipCustomImageView(systemName: iconName, style: iconStyle)
            }
        }
    }
}
