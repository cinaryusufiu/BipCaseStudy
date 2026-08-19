//
//  ProductLocalDataSource.swift
//  BipCaseStudy
//
//  Created by Yusuf Cinar on 17.08.2026.
//

import CoreData
import NetworkKit

final class ProductLocalDataSource: ProductDataSourceProtocol {

    private let coreDataStack: CoreDataStackProtocol

    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Fetch

    func fetchProducts() async -> Result<[Product], NetworkError> {
        let results: [CDProduct] = coreDataStack.viewContext.fetchAll(
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]
        )
        let products = results.map { $0.asProduct }
        guard !products.isEmpty else { return .failure(NetworkError(ResponseErrorType.noData)) }
        return .success(products)
    }

    func fetchProductDetail(id: String) async -> Result<ProductDetail, NetworkError> {
        guard let result: CDProduct = coreDataStack.viewContext.fetchFirst(uniqueValue: id) else {
            return .failure(NetworkError(ResponseErrorType.noData))
        }
        return .success(result.asProductDetail)
    }

    // MARK: - Save

    func saveProducts(_ products: [Product]) {
        let context = coreDataStack.newBackgroundContext()
        context.performAndWait {
            products.forEach { product in
                let cdProduct: CDProduct = context.findOrCreate(uniqueValue: product.productId)
                cdProduct.mapFromProduct(product)
            }
            try? context.save()
        }
    }

    func saveProductDetail(_ detail: ProductDetail) {
        let context = coreDataStack.newBackgroundContext()
        context.performAndWait {
            let cdProduct: CDProduct = context.findOrCreate(uniqueValue: detail.productId)
            cdProduct.mapFromProductDetail(detail)
            try? context.save()
        }
    }

    // MARK: - Delete

    func clearAll() {
        let context = coreDataStack.newBackgroundContext()
        context.performAndWait {
            context.deleteAll(CDProduct.self)
            try? context.save()
        }
    }
}
