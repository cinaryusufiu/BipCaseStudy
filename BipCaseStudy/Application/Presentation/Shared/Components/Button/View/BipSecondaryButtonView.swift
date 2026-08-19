//
//  BipSecondaryButtonView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipSecondaryButtonView: View {

    let config: BipButtonConfig
    private let provider: BipSecondaryButtonProvider

    init(config: BipButtonConfig, provider: BipSecondaryButtonProvider = BipSecondaryButtonProvider()) {
        self.config = config
        self.provider = provider
    }

    var body: some View {
        provider.createButton(config: config)
    }
}
