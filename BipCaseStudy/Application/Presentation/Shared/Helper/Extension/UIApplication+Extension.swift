//
//  UIApplication+Extension.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import UIKit

extension UIApplication {

    var currentWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
