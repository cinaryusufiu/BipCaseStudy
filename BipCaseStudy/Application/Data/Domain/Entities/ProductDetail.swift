//
//  ProductDetail.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation

struct ProductDetail: Codable, Equatable {
    let productId: String
    let name: String
    let price: Int
    let image: String?
    let description: String?
}
