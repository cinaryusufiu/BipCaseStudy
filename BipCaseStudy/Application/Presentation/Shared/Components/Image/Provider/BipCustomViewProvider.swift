//
//  BipCustomViewProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

struct BipCustomViewProvider: BipImageViewProviderProtocol {

    let imageURL: String?
    let systemName: String?
    let imageName: String?
    let style: BipImageStyle

    init(
        url: String? = nil,
        systemName: String? = nil,
        name: String? = nil,
        style: BipImageStyle
    ) {
        self.imageURL = url
        self.systemName = systemName
        self.imageName = name
        self.style = style
    }
}
