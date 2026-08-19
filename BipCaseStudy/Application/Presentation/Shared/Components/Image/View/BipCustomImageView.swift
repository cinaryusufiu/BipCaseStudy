//
//  BipCustomImageView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipCustomImageView: View {

    private let provider: BipCustomViewProvider

    init(
        url: String? = nil,
        systemName: String? = nil,
        name: String? = nil,
        style: BipImageStyle
    ) {
        self.provider = BipCustomViewProvider(
            url: url,
            systemName: systemName,
            name: name,
            style: style
        )
    }

    var body: some View {
        BipImageView(provider: provider)
    }
}
