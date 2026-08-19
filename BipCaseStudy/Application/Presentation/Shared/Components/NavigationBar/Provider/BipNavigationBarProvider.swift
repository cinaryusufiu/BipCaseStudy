//
//  BipNavigationBarProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Protocol

protocol NavigationBarProviding {
    func createNavigationBar(_ config: BipNavigationBarConfig) -> AnyView
}

// MARK: - Default Provider

struct BipNavigationBarProvider: NavigationBarProviding {

    private let iconStyle = BipImageStyle(width: 20, height: 20, contentMode: .fit)
    private let barHeight: CGFloat = 44

    func createNavigationBar(_ config: BipNavigationBarConfig) -> AnyView {
        AnyView(
            HStack(spacing: 0) {
                leftButtonView(config.leftButton)
                Spacer()
                titleView(config)
                Spacer()
                rightButtonView(config.rightButton)
            }
            .frame(height: barHeight)
            .padding(.horizontal, BipSpacing.medium)
            .background(config.backgroundColor)
        )
    }

    // MARK: - Private

    @ViewBuilder
    private func leftButtonView(_ model: BipBarButtonModel?) -> some View {
        if let model {
            Button(action: model.action) {
                BipCustomImageView(
                    systemName: model.icon,
                    style: BipImageStyle(
                        width: iconStyle.width,
                        height: iconStyle.height,
                        tintColor: model.tintColor,
                        contentMode: .fit
                    )
                )
            }
            .frame(width: 44, height: 44)
        } else {
            Spacer().frame(width: 44)
        }
    }

    @ViewBuilder
    private func rightButtonView(_ model: BipBarButtonModel?) -> some View {
        if let model {
            Button(action: model.action) {
                BipCustomImageView(
                    systemName: model.icon,
                    style: BipImageStyle(
                        width: iconStyle.width,
                        height: iconStyle.height,
                        tintColor: model.tintColor,
                        contentMode: .fit
                    )
                )
            }
            .frame(width: 44, height: 44)
        } else {
            Spacer().frame(width: 44)
        }
    }

    private func titleView(_ config: BipNavigationBarConfig) -> some View {
        StyledText(
            config.title,
            provider: HeadlineTextProvider(color: config.titleColor)
        )
    }
}

// MARK: - View Modifier

extension View {
    func addNavigationBar(
        config: BipNavigationBarConfig,
        using provider: NavigationBarProviding = BipNavigationBarProvider()
    ) -> some View {
        VStack(spacing: 0) {
            provider.createNavigationBar(config)
            self
        }
    }
}
