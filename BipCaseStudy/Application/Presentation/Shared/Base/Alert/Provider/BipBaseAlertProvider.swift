//
//  BipBaseAlertProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

class BipBaseAlertProvider: BipAlertProviderProtocol {

    let type: BipAlertType
    private let title: String
    private let message: String
    private let buttons: [BipAlertButtonModel]

    init(
        type: BipAlertType,
        title: String,
        message: String,
        buttons: [BipAlertButtonModel]
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.buttons = buttons
    }

    func createAlert() -> BipAlertModel {
        BipAlertModel(
            type: type,
            title: title,
            message: message,
            buttons: buttons
        )
    }
}
