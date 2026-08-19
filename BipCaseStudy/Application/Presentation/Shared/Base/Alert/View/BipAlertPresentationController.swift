//
//  BipAlertPresentationController.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import UIKit

final class BipAlertPresentationController: UIPresentationController {

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = containerView?.bounds ?? .zero
    }
}
