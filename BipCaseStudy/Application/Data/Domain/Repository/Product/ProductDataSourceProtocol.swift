//
//  ProductDataSourceProtocol.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
import NetworkKit

protocol ProductDataSourceProtocol {
    func fetchProducts() async -> Result<[Product], NetworkError>
    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError>
    func saveProducts(_ products: [Product])
    func saveProductDetail(_ detail: ProductDetail)
    func clearAll()
}
