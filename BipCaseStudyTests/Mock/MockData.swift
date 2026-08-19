//
//  MockData.swift
//  BipCaseStudyTests
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import Foundation
@testable import BipCaseStudy

enum MockData {

    static let sampleProduct = Product(
        productId: "1",
        name: "Apples",
        price: 120,
        image: "https://example.com/images/1.jpg"
    )

    static let sampleProduct2 = Product(
        productId: "2",
        name: "Oranges",
        price: 167,
        image: "https://example.com/images/2.jpg"
    )

    static let sampleProducts: [Product] = [sampleProduct, sampleProduct2]

    static let sampleProductDetail = ProductDetail(
        productId: "1",
        name: "Apples",
        price: 120,
        image: "https://example.com/images/1.jpg",
        description: "An apple a day keeps the doctor away."
    )

    static let sampleProductDetailWithoutDescription = ProductDetail(
        productId: "1",
        name: "Apples",
        price: 120,
        image: "https://example.com/images/1.jpg",
        description: nil
    )

    static let sampleProductListResponse = ProductListResponse(
        products: sampleProducts
    )

    static var sampleProductListJSON: Data {
        """
        {
            "products": [
                {
                    "product_id": "1",
                    "name": "Apples",
                    "price": 120,
                    "image": "https://example.com/images/1.jpg"
                },
                {
                    "product_id": "2",
                    "name": "Oranges",
                    "price": 167,
                    "image": "https://example.com/images/2.jpg"
                }
            ]
        }
        """.data(using: .utf8)!
    }

    static var sampleProductDetailJSON: Data {
        """
        {
            "product_id": "1",
            "name": "Apples",
            "price": 120,
            "image": "https://example.com/images/1.jpg",
            "description": "An apple a day keeps the doctor away."
        }
        """.data(using: .utf8)!
    }
}
