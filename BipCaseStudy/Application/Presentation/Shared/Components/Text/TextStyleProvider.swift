//
//  TextStyleProvider.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import SwiftUI

// MARK: - Protocol (Strategy Pattern)

protocol TextStyleProvider {
    var font: Font { get }
    var color: Color { get }
    var alignment: TextAlignment { get }
    var lineLimit: Int? { get }
}
