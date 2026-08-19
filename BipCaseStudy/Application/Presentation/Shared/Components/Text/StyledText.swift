//
//  StyledText.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct StyledText: View {
    let text: String
    let provider: TextStyleProvider

    init(_ text: String, provider: TextStyleProvider = BodyTextProvider()) {
        self.text = text
        self.provider = provider
    }

    var body: some View {
        Text(text)
            .font(provider.font)
            .foregroundColor(provider.color)
            .multilineTextAlignment(provider.alignment)
            .lineLimit(provider.lineLimit)
    }
}
