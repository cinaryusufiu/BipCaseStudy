//
//  BipRoundedViewProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipRoundedViewProvider: BipImageViewProviderProtocol {

    let imageURL: String?
    let systemName: String?
    let imageName: String?
    let style: BipImageStyle

    init(
        url: String? = nil,
        systemName: String? = nil,
        name: String? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 0,
        contentMode: ContentMode = .fill
    ) {
        self.imageURL = url
        self.systemName = systemName
        self.imageName = name
        self.style = BipImageStyle(
            width: width,
            height: height,
            shape: .rounded(cornerRadius),
            contentMode: contentMode
        )
    }
}
