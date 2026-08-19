//
//  BipAlertView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipAlertView: View {

    let alert: BipAlertModel
    @State private var isVisible: Bool = false

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundLayer
            alertContent
        }
    }
}

// MARK: - Background

extension BipAlertView {

    private var backgroundLayer: some View {
        Color.black
            .opacity(0.5)
            .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - Content

extension BipAlertView {

    private var alertContent: some View {
        VStack(spacing: 0) {
            iconView
            titleView
            messageView
            buttonsView
        }
        .padding(BipSpacing.large)
        .frame(width: UIScreen.main.bounds.width - 48)
        .background(Color.white)
        .cornerRadius(BipSpacing.medium)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
        .scaleEffect(isVisible ? 1.0 : 0.5)
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(
            isVisible
                ? .spring(response: 0.15, dampingFraction: 0.6)
                : .easeInOut(duration: 0.1),
            value: isVisible
        )
        .onAppear { isVisible = true }
        .onDisappear { isVisible = false }
    }
}

// MARK: - Components

extension BipAlertView {

    private var iconView: some View {
        BipCustomImageView(
            systemName: alert.type.defaultIcon,
            style: BipImageStyle(
                width: 48,
                height: 48,
                tintColor: alert.type.tintColor.toColor(),
                contentMode: .fit
            )
        )
        .padding(.bottom, BipSpacing.medium)
    }

    private var titleView: some View {
        StyledText(alert.title, provider: HeadlineTextProvider())
            .padding(.bottom, BipSpacing.xSmall)
    }

    private var messageView: some View {
        StyledText(alert.message, provider: SecondaryTextProvider(alignment: .center))
            .padding(.bottom, BipSpacing.large)
    }

    private var buttonsView: some View {
        VStack(spacing: BipSpacing.small) {
            ForEach(alert.buttons.indices, id: \.self) { index in
                alert.buttons[index].provider
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
