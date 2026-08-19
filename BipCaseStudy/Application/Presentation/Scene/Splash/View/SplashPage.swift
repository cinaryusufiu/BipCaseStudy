//
//  SplashPage.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct SplashPage: View {

    @EnvironmentObject var viewModel: SplashViewModel
    @State private var isAnimating = false

    // MARK: - Body

    var body: some View {
        BipPageView(viewModel: viewModel) {
            ZStack {
                BackgroundColorProvider.primary.toColor()
                    .ignoresSafeArea()

                splashContent
            }
        }
        .task {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            navigateToProductList()
        }
    }
}

// MARK: - Navigation

extension SplashPage {

    private func navigateToProductList() {
        let viewModel = ProductFactory.makeProductListVM()
        AppRouter.shared.setRoot(ProductListPage(), viewModel: viewModel, animated: true)
    }
}

// MARK: - Content

extension SplashPage {

    private var splashContent: some View {
        VStack(spacing: BipSpacing.medium) {
            splashIcon
            appTitle
        }
    }
}

// MARK: - Components

extension SplashPage {

    private var splashIcon: some View {
        BipCustomImageView(
            systemName: BipIcons.bag,
            style: BipImageStyle(
                width: 72,
                height: 72,
                tintColor: StatusColorProvider.accent.toColor(),
                contentMode: .fit
            )
        )
        .scaleEffect(isAnimating ? 1.0 : 0.5)
        .opacity(isAnimating ? 1.0 : 0.0)
    }

    private var appTitle: some View {
        StyledText("app_name".localized, provider: LargeTitleTextProvider())
            .opacity(isAnimating ? 1.0 : 0.0)
    }
}
