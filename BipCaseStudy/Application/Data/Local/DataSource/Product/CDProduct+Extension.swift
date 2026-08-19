//
//  CDProduct+Extension.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import CoreData

// MARK: - CachableEntity

extension CDProduct: CachableEntity {
    static var entityName: String { "CDProduct" }
    static var uniqueKeyPath: String { "productId" }
}

// MARK: - Domain Conversion

extension CDProduct {

    var asProduct: Product {
        Product(
            productId: productId ?? "",
            name: name ?? "",
            price: Int(price),
            image: imageURL
        )
    }

    var asProductDetail: ProductDetail {
        ProductDetail(
            productId: productId ?? "",
            name: name ?? "",
            price: Int(price),
            image: imageURL,
            description: productDescription
        )
    }
}

// MARK: - Domain Mapping

extension CDProduct {

    func mapFromProduct(_ product: Product) {
        self.productId = product.productId
        self.name = product.name
        self.price = Int32(product.price)
        self.imageURL = product.image
        self.cachedAt = Date()
    }

    func mapFromProductDetail(_ detail: ProductDetail) {
        self.productId = detail.productId
        self.name = detail.name
        self.price = Int32(detail.price)
        self.imageURL = detail.image
        self.productDescription = detail.description
        self.cachedAt = Date()
    }
}
