//
//  BipScrollView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipScrollView<Content: View>: View {

    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: Content

    init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    // MARK: - Body

    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content
        }
    }
}
