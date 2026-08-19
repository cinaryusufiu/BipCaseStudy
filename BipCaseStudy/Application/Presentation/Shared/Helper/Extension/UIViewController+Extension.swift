//
//  UIViewController+Extension.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import UIKit

extension UIViewController {

    var topMostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }

    func configureTransparentStyle(using delegate: UIViewControllerTransitioningDelegate?) {
        transitioningDelegate = delegate
        modalPresentationStyle = .custom
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        view.isOpaque = false
        view.backgroundColor = .clear
    }
}
