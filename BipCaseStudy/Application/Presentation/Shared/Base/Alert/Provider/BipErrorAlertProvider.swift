//
//  BipErrorAlertProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

final class BipErrorAlertProvider: BipBaseAlertProvider {

    init(
        title: String,
        message: String,
        icon: String? = nil,
        buttons: [BipAlertButtonModel]
    ) {
        super.init(
            type: .error(icon: icon),
            title: title,
            message: message,
            buttons: buttons
        )
    }
}
