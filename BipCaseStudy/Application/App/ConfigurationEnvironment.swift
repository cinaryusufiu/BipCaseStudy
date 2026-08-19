//
//  ConfigurationEnvironment.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Environment

enum ConfigurationEnvironment: String {
    case debug
    case development
    case production

    static var current: ConfigurationEnvironment {
        #if DEVELOPMENT
        return .development
        #elseif DEBUG
        return .debug
        #else
        return .production
        #endif
    }
}

// MARK: - Properties

extension ConfigurationEnvironment {

    var displayName: String { rawValue.capitalized }

    var configFileName: String {
        switch self {
        case .debug:        return "Configuration-Debug"
        case .development:  return "Configuration-Dev"
        case .production:   return "Configuration-Release"
        }
    }
}
