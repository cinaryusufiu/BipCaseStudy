//
//  BipButtonConfig.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - ButtonProviding Protocol

protocol ButtonProviding {
    associatedtype ButtonView: View
    func createButton(config: BipButtonConfig) -> ButtonView
}

// MARK: - Button Config

struct BipButtonConfig {

    enum IconPosition {
        case left
        case right
    }

    var label: String
    var iconName: String?
    var iconPosition: IconPosition?
    var buttonHeight: CGFloat = 48
    var cornerRadius: CGFloat = 12
    var isDisabled: Bool = false
    var onTap: Completion
}
