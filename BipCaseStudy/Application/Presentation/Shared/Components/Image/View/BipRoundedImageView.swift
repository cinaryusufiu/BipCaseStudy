//
//  BipRoundedImageView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipRoundedImageView: View {

    private let provider: BipRoundedViewProvider

    init(
        url: String? = nil,
        systemName: String? = nil,
        name: String? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 0,
        contentMode: ContentMode = .fill
    ) {
        self.provider = BipRoundedViewProvider(
            url: url,
            systemName: systemName,
            name: name,
            width: width,
            height: height,
            cornerRadius: cornerRadius,
            contentMode: contentMode
        )
    }

    var body: some View {
        BipImageView(provider: provider)
    }
}
