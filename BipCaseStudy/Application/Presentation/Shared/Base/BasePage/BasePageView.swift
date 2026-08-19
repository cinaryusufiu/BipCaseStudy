//
//  BasePageView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BasePageView<Content: View, VM: BaseViewModelProtocol>: View {

    @ObservedObject var viewModel: VM
    let content: Content
    var onTapGesture: Completion?

    init(
        viewModel: VM,
        onTapGesture: Completion? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.onTapGesture = onTapGesture
        self.content = content()
    }

    var body: some View {
        content
            .onTapGesture { onTapGesture?() }
    }
}
