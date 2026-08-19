//
//  BipSuccessAlertProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

final class BipSuccessAlertProvider: BipBaseAlertProvider {

    init(
        title: String,
        message: String,
        icon: String? = nil,
        buttons: [BipAlertButtonModel]
    ) {
        super.init(
            type: .success(icon: icon),
            title: title,
            message: message,
            buttons: buttons
        )
    }
}
