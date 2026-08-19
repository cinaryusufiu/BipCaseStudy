//
//  Product.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
    let productId: String
    let name: String
    let price: Int
    let image: String?

    var id: String { productId }
}
