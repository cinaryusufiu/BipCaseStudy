//
//  BipOutlineButtonProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipOutlineButtonProvider: ButtonProviding {

    private let iconStyle = BipImageStyle(width: 16, height: 16, contentMode: .fit)

    func createButton(config: BipButtonConfig) -> some View {
        Button(action: config.onTap) {
            createContent(config: config)
                .frame(maxWidth: .infinity)
                .frame(height: config.buttonHeight)
                .background(BackgroundColorProvider.secondary.toColor())
                .foregroundColor(
                    config.isDisabled
                        ? TextColorProvider.secondary.toColor()
                        : TextColorProvider.primary.toColor()
                )
                .cornerRadius(config.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .stroke(UtilityColorProvider.border.toColor(), lineWidth: 1.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(config.isDisabled)
    }
}

// MARK: - Private

extension BipOutlineButtonProvider {

    @ViewBuilder
    private func createContent(config: BipButtonConfig) -> some View {
        HStack(spacing: 8) {
            if config.iconPosition == .left, let iconName = config.iconName {
                BipCustomImageView(systemName: iconName, style: iconStyle)
            }

            StyledText(config.label, provider: ButtonTextProvider(color: TextColorProvider.primary.toColor()))

            if config.iconPosition == .right, let iconName = config.iconName {
                BipCustomImageView(systemName: iconName, style: iconStyle)
            }
        }
    }
}
