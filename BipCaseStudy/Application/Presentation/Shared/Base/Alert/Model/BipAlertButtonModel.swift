//
//  BipAlertButtonModel.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

struct BipAlertButtonModel {
    let title: String
    let action: Completion
    let provider: AnyView

    init<T: ButtonProviding>(
        title: String,
        action: @escaping Completion,
        provider: T
    ) {
        self.title = title
        self.action = {
            Task { @MainActor in
                ServiceLocator.shared.alertManager?.dismiss()
                try? await Task.sleep(nanoseconds: 200_000_000)
                action()
            }
        }
        self.provider = AnyView(
            provider.createButton(config: BipButtonConfig(
                label: title,
                onTap: self.action
            ))
        )
    }
}
