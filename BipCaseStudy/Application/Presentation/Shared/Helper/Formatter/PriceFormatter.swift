//
//  PriceFormatter.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

// MARK: - Protocol

protocol PriceFormatterStrategy {
    func format(cents: Int) -> String
}

// MARK: - Dollar Formatter

final class DollarPriceFormatter: PriceFormatterStrategy {

    func format(cents: Int) -> String {
        let value = Double(cents) / 100.0
        return String(format: "$%.2f", value)
    }
}
