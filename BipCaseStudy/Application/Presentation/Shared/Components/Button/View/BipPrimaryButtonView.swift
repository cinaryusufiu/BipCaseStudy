//
//  BipPrimaryButtonView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipPrimaryButtonView: View {

    let config: BipButtonConfig
    private let provider: BipPrimaryButtonProvider

    init(config: BipButtonConfig, provider: BipPrimaryButtonProvider = BipPrimaryButtonProvider()) {
        self.config = config
        self.provider = provider
    }

    var body: some View {
        provider.createButton(config: config)
    }
}
