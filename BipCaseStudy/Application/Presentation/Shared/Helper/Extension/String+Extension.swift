//
//  String+Extension.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Computed Properties

extension String {

    var isNotEmpty: Bool { !isEmpty }

    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

// MARK: - Optional String

extension Optional where Wrapped == String {

    var orEmpty: String { self ?? "" }

    var isNilOrEmpty: Bool {
        switch self {
        case .none: return true
        case .some(let value): return value.isEmpty
        }
    }
}
