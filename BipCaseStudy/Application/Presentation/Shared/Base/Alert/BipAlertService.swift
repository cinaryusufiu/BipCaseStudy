//
//  BipAlertService.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

@MainActor
enum BipAlertService {

    // MARK: - Error

    static func triggerErrorAlert(
        title: String = "error_title".localized,
        message: String,
        buttonTitle: String = "ok".localized,
        action: @escaping Completion = {}
    ) {
        let button = BipAlertButtonModel(
            title: buttonTitle,
            action: action,
            provider: BipPrimaryButtonProvider()
        )
        let provider = BipErrorAlertProvider(
            title: title,
            message: message,
            buttons: [button]
        )
        ServiceLocator.shared.alertManager?.showAlert(using: provider)
    }

    // MARK: - Info

    static func triggerInfoAlert(
        title: String = "info_title".localized,
        message: String,
        buttonTitle: String = "ok".localized,
        action: @escaping Completion = {}
    ) {
        let button = BipAlertButtonModel(
            title: buttonTitle,
            action: action,
            provider: BipPrimaryButtonProvider()
        )
        let provider = BipInfoAlertProvider(
            title: title,
            message: message,
            buttons: [button]
        )
        ServiceLocator.shared.alertManager?.showAlert(using: provider)
    }

    // MARK: - Confirmation

    static func triggerConfirmationAlert(
        title: String,
        message: String,
        confirmTitle: String = "confirm".localized,
        cancelTitle: String = "cancel".localized,
        onConfirm: @escaping Completion,
        onCancel: @escaping Completion = {}
    ) {
        let confirmButton = BipAlertButtonModel(
            title: confirmTitle,
            action: onConfirm,
            provider: BipPrimaryButtonProvider()
        )
        let cancelButton = BipAlertButtonModel(
            title: cancelTitle,
            action: onCancel,
            provider: BipOutlineButtonProvider()
        )
        let provider = BipInfoAlertProvider(
            title: title,
            message: message,
            buttons: [confirmButton, cancelButton]
        )
        ServiceLocator.shared.alertManager?.showAlert(using: provider)
    }

    // MARK: - Success

    static func triggerSuccessAlert(
        title: String = "success_title".localized,
        message: String,
        buttonTitle: String = "ok".localized,
        action: @escaping Completion = {}
    ) {
        let button = BipAlertButtonModel(
            title: buttonTitle,
            action: action,
            provider: BipPrimaryButtonProvider()
        )
        let provider = BipSuccessAlertProvider(
            title: title,
            message: message,
            buttons: [button]
        )
        ServiceLocator.shared.alertManager?.showAlert(using: provider)
    }
}
