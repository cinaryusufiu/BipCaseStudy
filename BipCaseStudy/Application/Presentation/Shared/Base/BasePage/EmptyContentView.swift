//
//  EmptyContentView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct EmptyContentView: View {

    let model: BipEmptyModel

    // MARK: - Body

    var body: some View {
        VStack(spacing: BipSpacing.medium) {
            emptyIcon
            emptyTitle
            emptyMessage
            retryButton
        }
        .padding(BipSpacing.xLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Components

extension EmptyContentView {

    private var emptyIcon: some View {
        BipCustomImageView(
            systemName: model.icon,
            style: BipImageStyle(
                width: 60,
                height: 60,
                tintColor: TextColorProvider.secondary.toColor(),
                contentMode: .fit
            )
        )
    }

    private var emptyTitle: some View {
        StyledText(model.title, provider: HeadlineTextProvider())
    }

    private var emptyMessage: some View {
        StyledText(model.message, provider: SecondaryTextProvider(alignment: .center))
    }

    @ViewBuilder
    private var retryButton: some View {
        if let buttonTitle = model.buttonTitle {
            BipPrimaryButtonView(
                config: BipButtonConfig(
                    label: buttonTitle,
                    onTap: { model.onButtonTap?() }
                )
            )
            .frame(width: 180)
            .padding(.top, BipSpacing.xSmall)
        }
    }
}
