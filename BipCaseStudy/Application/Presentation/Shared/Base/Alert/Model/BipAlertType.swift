//
//  BipAlertType.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

enum BipAlertType {
    case success(icon: String?)
    case error(icon: String?)
    case warning(icon: String?)
    case info(icon: String?)

    var defaultIcon: String {
        switch self {
        case .success(let icon): return icon ?? BipIcons.alertSuccess
        case .error(let icon): return icon ?? BipIcons.alertError
        case .warning(let icon): return icon ?? BipIcons.alertWarning
        case .info(let icon): return icon ?? BipIcons.alertInfo
        }
    }

    var tintColor: any BipColorConvertible {
        switch self {
        case .success: return StatusColorProvider.success
        case .error: return StatusColorProvider.error
        case .warning: return StatusColorProvider.warning
        case .info: return StatusColorProvider.accent
        }
    }
}
