//
//  BipAlertManager.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI
import UIKit

// MARK: - Protocol

@MainActor
protocol BipAlertManagerProtocol {
    func showAlert(using provider: BipAlertProviderProtocol)
    func dismiss(completion: Completion?)
}

extension BipAlertManagerProtocol {
    func dismiss() { dismiss(completion: nil) }
}

// MARK: - Implementation

@MainActor
final class BipAlertManager: NSObject, UIViewControllerTransitioningDelegate, BipAlertManagerProtocol {

    private var isAlertPresented: Bool = false

    override init() {}

    // MARK: - Public

    func showAlert(using provider: BipAlertProviderProtocol) {
        guard let window = UIApplication.shared.currentWindow else { return }

        guard !isAlertPresented else {
            dismiss { self.presentAlert(using: provider, on: window) }
            return
        }
        presentAlert(using: provider, on: window)
    }

    func dismiss(completion: Completion? = nil) {
        guard let window = UIApplication.shared.currentWindow else {
            completion?()
            return
        }
        window.rootViewController?.topMostViewController.dismiss(animated: false) {
            self.isAlertPresented = false
            completion?()
        }
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        BipAlertPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }

    // MARK: - Private

    private func presentAlert(using provider: BipAlertProviderProtocol, on window: UIWindow) {
        let alert = provider.createAlert()
        let alertView = BipAlertView(alert: alert)
        let hostController = UIHostingController(rootView: alertView)
        hostController.configureTransparentStyle(using: self)

        window.rootViewController?.topMostViewController.present(hostController, animated: false) {
            self.isAlertPresented = true
        }
    }
}
