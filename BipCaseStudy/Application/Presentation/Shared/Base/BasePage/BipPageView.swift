//
//  BipPageView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipPageView<Content: View, VM: BaseViewModel>: View {

    @ObservedObject var viewModel: VM
    let content: Content

    init(viewModel: VM, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        BasePageView(viewModel: viewModel) {
            buildStateView()
        }
    }
}

// MARK: - State View

extension BipPageView {

    @ViewBuilder
    private func buildStateView() -> some View {
        switch viewModel.pageState {
        case .loading:
            LoadingView()

        case .content:
            content

        case .noContent:
            if let model = viewModel.emptyModel {
                EmptyContentView(model: model)
            }
        }
    }
}
