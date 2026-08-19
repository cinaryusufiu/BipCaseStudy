//
//  BipOutlineButtonView.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipOutlineButtonView: View {

    let config: BipButtonConfig
    private let provider: BipOutlineButtonProvider

    init(config: BipButtonConfig, provider: BipOutlineButtonProvider = BipOutlineButtonProvider()) {
        self.config = config
        self.provider = provider
    }

    var body: some View {
        provider.createButton(config: config)
    }
}
